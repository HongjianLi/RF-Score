#include <iostream>
#include <iomanip>
#include <string>
#include <algorithm>
#include "feature.hpp"
using namespace std;

int main(int argc, char* argv[])
{
	if (argc < 2)
	{
		cout << "rf-prepare /path/to/PDBbind/v2012/pdbbind-2012-core-iy.csv model scheme" << endl;
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

	const string path = argv[1];
	const string root = path.substr(0, path.find_last_of("/\\") + 1);
	const size_t model = argc == 2 ? 4 : stoul(argv[2]); // model can be 2, 3 or 4.
	const string scheme = argc <= 3 ? "1" : argv[3]; // scheme can be 0, 1, 2, 3, 4, 5 or 6.
	const size_t nf = (model == 4 ? 36 : 0) + 10;
	const size_t np = (scheme == "5" ? 9 : (scheme == "6" ? 2 : 1));

	// Construct the header based on model.
	cout << "pbindaff";
	if (np == 1)
	{
		if (model == 4)
		{
			for (const auto& h : h36)
			{
				cout << ',' << h;
			}
		}
		for (const auto& h : h10)
		{
			cout << ',' << h;
		}
	}
	else
	{
		for (size_t p = 1; p <= np; ++p)
		{
			if (model == 4)
			{
				for (const auto& h : h36)
				{
					cout << ',' << h << '_' << p;
				}
			}
			for (const auto& h : h10)
			{
				cout << ',' << h << '_' << p;
			}
		}
	}
	if (model == 2)
	{
		for (const auto& h : h2)
		{
			cout << ',' << h;
		}
	}
	else
	{
		for (const auto& h : h1)
		{
			cout << ',' << h;
		}
	}
	cout << ",PDB\n" << setprecision(4);
	cout.setf(ios::fixed, ios::floatfield);

	// Traverse the PDBbind folder to extract RF-Score features and Vina terms.
	string line;
	for (ifstream ifs(argv[1]); getline(ifs, line);)
	{
		const string code = line.substr(0, 4);
		const float pbindaff = stof(line.substr(5));
		receptor rec;
		rec.load(root + code + "/" + code + "_protein.pdbqt");
		vector<float> v;
		if (scheme == "1")
		{
			ligand lig;
			lig.load(root + code + "/" + code + "_ligand.pdbqt");
			v = feature(rec, lig, model);
		}
		else if (scheme == "5" || scheme == "6")
		{
			ifstream ifs(root + code + "/out/conformation_count.txt");
			getline(ifs, line);
			const size_t c = stoul(line);
			const size_t m = min<size_t>(c, np);
			vector<float> t;
			v.resize(nf * np + (model == 2 ? 2 : 1));
			size_t p = 0;
			for (size_t i = c; i < np; ++i)
			{
				ligand lig;
				lig.load(root + code + "/out/" + code + "_ligand_ligand_1.pdbqt");
				t = feature(rec, lig, model);
				for (size_t j = 0; j < nf; ++j)
				{
					v[p++] = t[j];
				}
			}
			for (size_t i = 1; i <= m; ++i)
			{
				ligand lig;
				lig.load(root + code + "/out/" + code + "_ligand_ligand_" + to_string(i) + ".pdbqt");
				t = feature(rec, lig, model);
				for (size_t j = 0; j < nf; ++j)
				{
					v[p++] = t[j];
				}
			}
			if (model == 2)
			{
				v[p++] = t[10];
				v[p++] = t[11];
			}
			else
			{
				v[p++] = t.back();
			}
		}
		else
		{
			ifstream ifs(root + code + "/vina-scheme-" + scheme + ".txt");
			getline(ifs, line);
			ligand lig;
			lig.load(root + code + "/out/" + code + "_ligand_ligand_" + line + ".pdbqt");
			v = feature(rec, lig, model);
		}
		cout << pbindaff;
		for (const auto d : v)
		{
			cout << ',' << d;
		}
		cout << ',' << code << '\n';
	}
}
