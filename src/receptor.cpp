#include <string>
#include <fstream>
#include "receptor.hpp"

void receptor::load(const string path)
{
	ifstream ifs(path);
	load(ifs);
}

void receptor::load(ifstream& ifs)
{
	// Parse the receptor line by line.
	reserve(2000); // A receptor typically consists of <= 2,000 atoms within bound.
	string residue = "XXXX"; // Current residue sequence located at 1-based [23, 26], used to track residue change, initialized to a dummy value.
	size_t residue_start; // The starting atom of the current residue.
	for (string line; getline(ifs, line);)
	{
		const string record = line.substr(0, 6);
		if (record == "ATOM  " || record == "HETATM")
		{
			// If this line is the start of a new residue, mark the starting index within the atoms vector.
			if (line[25] != residue[3] || line[24] != residue[2] || line[23] != residue[1] || line[22] != residue[0])
			{
				residue[3] = line[25];
				residue[2] = line[24];
				residue[1] = line[23];
				residue[0] = line[22];
				residue_start = size();
			}

			// Parse the ATOM/HETATM line.
			atom a(line);

			// Harmonize a unsupported atom type to carbon.
			if (a.ad_unsupported()) a.ad = 2;

			// Skip non-polar hydrogens.
			if (a.is_nonpolar_hydrogen()) continue;

			// For a polar hydrogen, the bonded hetero atom must be a hydrogen bond donor.
			if (a.is_polar_hydrogen())
			{
				for (size_t i = size(); i > residue_start;)
				{
					atom& b = (*this)[--i];
					if (b.is_hetero() && b.has_covalent_bond(a))
					{
						b.donorize();
						break;
					}
				}
				continue;
			}

			// For a hetero atom, its connected carbon atoms are no longer hydrophobic.
			if (a.is_hetero())
			{
				for (size_t i = size(); i > residue_start;)
				{
					atom& b = (*this)[--i];
					if (!b.is_hetero() && b.has_covalent_bond(a))
					{
						b.dehydrophobicize();
					}
				}
			}
			// For a carbon atom, it is no longer hydrophobic when connected to a hetero atom.
			else
			{
				for (size_t i = size(); i > residue_start;)
				{
					const atom& b = (*this)[--i];
					if (b.is_hetero() && b.has_covalent_bond(a))
					{
						a.dehydrophobicize();
						break;
					}
				}
			}

			// Save the atom.
			push_back(move(a));
		}
		else if (record == "TER   ")
		{
			residue = "XXXX";
		}
	}
}
