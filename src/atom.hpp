#pragma once
#ifndef RF_SCORE_ATOM_HPP
#define RF_SCORE_ATOM_HPP

#include <array>
using namespace std;

class atom
{
private:
	static const size_t n = 33;
	static const array<string, n> ad_strings;
	static const array<float, n> ad_covalent_radii;
	static const array<size_t, n> ad_to_xs;
	static const array<size_t, n> ad_to_rf;
public:
	size_t serial;
	array<float, 3> coord;
	size_t ad;
	size_t xs;
	size_t rf;

	// Constructs an atom from an ATOM/HETATM line in PDBQT format.
	explicit atom(const string& line);

	/// Returns true if the AutoDock4 atom type is not supported.
	bool ad_unsupported() const;

	/// Returns true if the XScore atom type is not supported.
	bool xs_unsupported() const;

	/// Returns true if the RF-Score atom type is not supported.
	bool rf_unsupported() const;

	/// Returns true if the atom is a nonpolar hydrogen atom.
	bool is_nonpolar_hydrogen() const;

	/// Returns true if the atom is a polar hydrogen atom.
	bool is_polar_hydrogen() const;

	/// Returns true if the atom is a hydrogen atom.
	bool is_hydrogen() const;

	/// Returns true if the atom is a hetero atom, i.e. non-carbon heavy atom.
	bool is_hetero() const;

	/// For nitrogen and oxygen, revises the XScore atom type to make it a hydrogen bond donor.
	void donorize();

	/// For carbon, revises the XScore atom type to make it non-hydrophobic.
	void dehydrophobicize();

	/// Returns the covalent radius of current AutoDock4 atom type.
	float covalent_radius() const;

	/// Returns true if the current atom is covalently bonded to a given atom.
	bool has_covalent_bond(const atom& a) const;

	bool is_hydrophobic() const;
	bool is_aromatic() const;
	bool is_hbd() const;
	bool is_hba() const;
};

#endif
