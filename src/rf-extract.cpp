#include <iostream>
#include <iomanip>
#include <string>
#include <array>
#include <cassert>
#include "feature.hpp"
using namespace std;

int main(int argc, char* argv[])
{
	if (argc < 3)
	{
		cout << "rf-extract receptor.pdbqt ligand.pdbqt [model=4]" << endl;
		return 0;
	}

	const array<string, 36> h36 =
	{
		"6.6",
		"7.6",
		"8.6",
		"16.6",
		"6.7",
		"7.7",
		"8.7",
		"16.7",
		"6.8",
		"7.8",
		"8.8",
		"16.8",
		"6.16",
		"7.16",
		"8.16",
		"16.16",
		"6.15",
		"7.15",
		"8.15",
		"16.15",
		"6.9",
		"7.9",
		"8.9",
		"16.9",
		"6.17",
		"7.17",
		"8.17",
		"16.17",
		"6.35",
		"7.35",
		"8.35",
		"16.35",
		"6.53",
		"7.53",
		"8.53",
		"16.53",
	};
	const array<string, 10> h10 =
	{
		"gauss1_inter",
		"gauss2_inter",
		"repulsion_inter",
		"hydrophobic_inter",
		"hydrogenbonding_inter",
		"gauss1_intra",
		"gauss2_intra",
		"repulsion_intra",
		"hydrophobic_intra",
		"hydrogenbonding_intra",
	};
	const array<string, 1> h1 =
	{
		"flexibility",
	};
	const array<string, 2> h2 =
	{
		"nacttors",
		"ninacttors",
	};
	const size_t model = argc == 3 ? 4 : stoul(argv[3]); // model can be 2, 3 or 4.

	// Construct the header based on model.
	vector<string> h;
	h.reserve(11);
	if (model == 4)
	{
		h.insert(h.end(), h36.cbegin(), h36.cend());
	}
	h.insert(h.end(), h10.cbegin(), h10.cend());
	if (model == 2)
	{
		h.insert(h.end(), h2.cbegin(), h2.cend());
	}
	else
	{
		h.insert(h.end(), h1.cbegin(), h1.cend());
	}
	cout << h[0];
	for (size_t i = 1, n = h.size(); i < n; ++i)
	{
		cout << ',' << h[i];
	}
	cout << endl;

	// Load a receptor and multiple conformations of a ligand to calculate RF-Score features and Vina terms.
	cout.setf(ios::fixed, ios::floatfield);
	cout << setprecision(4);
	receptor rec;
	rec.load(argv[1]);
	for (ifstream ifs(argv[2]); true;)
	{
		ligand lig;
		lig.load(ifs);
		if (lig.empty()) break;
		const vector<float> v = feature(rec, lig, model);
		assert(v.size() == h.size());
		cout << v[0];
		for (size_t i = 1, n = v.size(); i < n; ++i)
		{
			cout << ',' << v[i];
		}
		cout << endl;
	}
}
