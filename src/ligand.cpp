#include <string>
#include <fstream>
#include <cassert>
#include <algorithm>
#include "ligand.hpp"

/// Represents a ROOT or a BRANCH in PDBQT structure.
class frame
{
public:
	size_t parent; ///< Frame array index pointing to the parent of current frame. For ROOT frame, this field is not used.
	size_t rotorXidx; ///< Index pointing to the parent frame atom which forms a rotatable bond with the rotorY atom of current frame.
	size_t rotorYidx; ///< Index pointing to the current frame atom which forms a rotatable bond with the rotorX atom of parent frame.
	size_t childYidx; //!< The exclusive ending index to the heavy atoms of the current frame.

	/// Constructs an active frame, and relates it to its parent frame.
	explicit frame(const size_t parent, const size_t rotorXidx, const size_t rotorYidx) : parent(parent), rotorXidx(rotorXidx), rotorYidx(rotorYidx) {}
};

void ligand::load(const string path)
{
	ifstream ifs(path);
	load(ifs);
}

void ligand::load(ifstream& ifs)
{
	// Initialize necessary variables for constructing a ligand.
	num_active_torsions = num_inactive_torsions = 0;
	vector<frame> frames; ///< ROOT and BRANCH frames.
	frames.reserve(30); // A ligand typically consists of <= 30 frames.
	frames.emplace_back(0, 0, 0); // ROOT is also treated as a frame. The parent, rotorXsrn, rotorYsrn, rotorXidx of ROOT frame are dummy.
	reserve(100); // A ligand typically consists of <= 100 heavy atoms.

	// Initialize helper variables for parsing.
	vector<atom> hydrogens; ///< Unsaved hydrogens of ROOT frame.
	vector<vector<size_t>> bonds; // Covalent bonds.
	bonds.reserve(100); // A ligand typically consists of <= 100 heavy atoms.
	size_t current = 0; // Index of current frame, initialized to ROOT frame.
	frame* f = &frames.front(); // Pointer to the current frame.

	// Parse the ligand line by line.
	for (string line; getline(ifs, line);)
	{
		const string record = line.substr(0, 6);
		if (record == "ATOM  " || record == "HETATM")
		{
			// Parse the line.
			atom a(line);

			// Skip non-polar hydrogens.
			if (a.is_nonpolar_hydrogen()) continue;

			// For a polar hydrogen, the bonded hetero atom must be a hydrogen bond donor.
			if (a.is_polar_hydrogen())
			{
				bool unsaved = true;
				for (size_t i = size(); i > f->rotorYidx;)
				{
					atom& b = (*this)[--i];
					if (a.has_covalent_bond(b))
					{
						b.donorize();
						unsaved = false;
						break;
					}
				}
				if (unsaved)
				{
					hydrogens.push_back(move(a));
				}
			}
			else // Current atom is a heavy atom.
			{
				// Find bonds between the current atom and the other atoms of the same frame.
				assert(bonds.size() == size());
				bonds.emplace_back();
				bonds.back().reserve(4); // An atom typically consists of <= 4 bonds.
				for (size_t i = size(); i > f->rotorYidx;)
				{
					atom& b = (*this)[--i];
					if (a.has_covalent_bond(b))
					{
						bonds[size()].push_back(i);
						bonds[i].push_back(size());

						// If carbon atom b is bonded to hetero atom a, b is no longer a hydrophobic atom.
						if (a.is_hetero() && !b.is_hetero())
						{
							b.dehydrophobicize();
						}
						// If carbon atom a is bonded to hetero atom b, a is no longer a hydrophobic atom.
						else if (!a.is_hetero() && b.is_hetero())
						{
							a.dehydrophobicize();
						}
					}
				}

				// Save the heavy atom.
				push_back(move(a));
			}
		}
		else if (record == "BRANCH")
		{
			// Parse "BRANCH   X   Y". X and Y are right-justified and 4 characters wide.
			const size_t rotorXsrn = stoul(line.substr( 6, 4));
			const size_t rotorYsrn = stoul(line.substr(10, 4));

			// Find the corresponding heavy atom with x as its atom serial number in the current frame.
			for (size_t i = f->rotorYidx; true; ++i)
			{
				if ((*this)[i].serial == rotorXsrn)
				{
					// Insert a new frame whose parent is the current frame.
					frames.push_back(frame(current, i, size()));
					break;
				}
			}

			// Now the current frame is the newly inserted BRANCH frame.
			current = frames.size() - 1;

			// Update the pointer to the current frame.
			f = &frames[current];

			// The ending index of atoms of previous frame is the starting index of atoms of current frame.
			frames[current - 1].childYidx = f->rotorYidx;
		}
		else if (record == "ENDBRA")
		{
			// If the current frame consists of rotor Y and a few hydrogens only, e.g. -OH, -NH2 or -CH3,
			// the torsion of this frame will have no effect on scoring and is thus redundant.
			if (current + 1 == frames.size() && f->rotorYidx + 1 == size())
			{
				++num_inactive_torsions;
			}
			else
			{
				++num_active_torsions;
			}

			// Set up bonds between rotorX and rotorY.
			bonds[f->rotorYidx].push_back(f->rotorXidx);
			bonds[f->rotorXidx].push_back(f->rotorYidx);

			// Dehydrophobicize rotorX and rotorY if necessary.
			atom& rotorY = (*this)[f->rotorYidx];
			atom& rotorX = (*this)[f->rotorXidx];
			if (rotorY.is_hetero() && !rotorX.is_hetero()) rotorX.dehydrophobicize();
			if (rotorX.is_hetero() && !rotorY.is_hetero()) rotorY.dehydrophobicize();

			// Now the parent of the following frame is the parent of current frame.
			current = f->parent;

			// Update the pointer to the current frame.
			f = &frames[current];
		}
		else if (record == "ENDROO")
		{
			for (const atom& a : hydrogens)
			{
				for (size_t i = size(); i > f->rotorYidx;)
				{
					atom& b = (*this)[--i];
					if (a.has_covalent_bond(b))
					{
						b.donorize();
						break;
					}
				}
			}
		}
		else if (record == "TORSDO") break;
	}
	assert(1 + num_active_torsions + num_inactive_torsions == frames.size());
	frames.back().childYidx = size();

	// Find intra-ligand interacting pairs that are not 1-4.
	interacting_pairs.reserve(size() * size());
	vector<size_t> neighbors;
	neighbors.reserve(10); // An atom typically consists of <= 10 neighbors.
	for (size_t k1 = 0; k1 < frames.size(); ++k1)
	{
		const frame& f1 = frames[k1];
		for (size_t i = f1.rotorYidx; i < f1.childYidx; ++i)
		{
			// Find neighbor atoms within 3 consecutive covalent bonds.
			for (const size_t b1 : bonds[i])
			{
				if (find(neighbors.cbegin(), neighbors.cend(), b1) == neighbors.cend())
				{
					neighbors.push_back(b1);
				}
				for (const size_t b2 : bonds[b1])
				{
					if (find(neighbors.cbegin(), neighbors.cend(), b2) == neighbors.cend())
					{
						neighbors.push_back(b2);
					}
					for (const size_t b3 : bonds[b2])
					{
						if (find(neighbors.cbegin(), neighbors.cend(), b3) == neighbors.cend())
						{
							neighbors.push_back(b3);
						}
					}
				}
			}

			// Determine if interacting pairs can be possibly formed.
			const size_t t1 = (*this)[i].xs;
			for (size_t k2 = k1 + 1; k2 < frames.size(); ++k2)
			{
				const frame& f2 = frames[k2];
				const frame& f3 = frames[f2.parent];
				for (size_t j = f2.rotorYidx; j < f2.childYidx; ++j)
				{
					if (k1 == f2.parent && (i == f2.rotorXidx || j == f2.rotorYidx)) continue;
					if (k1 > 0 && f1.parent == f2.parent && i == f1.rotorYidx && j == f2.rotorYidx) continue;
					if (f2.parent > 0 && k1 == f3.parent && i == f3.rotorXidx && j == f2.rotorYidx) continue;
					if (find(neighbors.cbegin(), neighbors.cend(), j) != neighbors.cend()) continue;
					interacting_pairs.emplace_back(i, j);
				}
			}

			// Clear the current neighbor set for the next atom.
			neighbors.clear();
		}
	}
}
