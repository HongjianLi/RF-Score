#include <iostream>
#include <iomanip>
#include <cassert>
#include "random_forest_test.hpp"
#include "feature.hpp"
using namespace std;

int main(int argc, char* argv[])
{
	if (argc < 3)
	{
		cout << "rf-score [pdbbind-2013-refined.rf] receptor.pdbqt ligand.pdbqt" << endl;
		return 0;
	}
	const bool score = argc > 3;

	// Load a random forest from file.
	forest f;
	if (score)
	{
		f.load(argv[1]);
	}
	else
	{
		cout << "6.6	7.6	8.6	16.6	6.7	7.7	8.7	16.7	6.8	7.8	8.8	16.8	6.16	7.16	8.16	16.16	6.15	7.15	8.15	16.15	6.9	7.9	8.9	16.9	6.17	7.17	8.17	16.17	6.35	7.35	8.35	16.35	6.53	7.53	8.53	16.53	gauss1	gauss2	repulsion	hydrophobic	hydrogenbonding	flexibility" << endl;
//		cout << "6.6	7.6	8.6	16.6	6.7	7.7	8.7	16.7	6.8	7.8	8.8	16.8	6.16	7.16	8.16	16.16	6.15	7.15	8.15	16.15	6.9	7.9	8.9	16.9	6.17	7.17	8.17	16.17	6.35	7.35	8.35	16.35	6.53	7.53	8.53	16.53	gauss1_inter	gauss2_inter	repulsion_inter	hydrophobic_inter	hydrogenbonding_inter	gauss1_intra	gauss2_intra	repulsion_intra	hydrophobic_intra	hydrogenbonding_intra	flexibility" << endl;
	}

	// Load a receptor and multiple conformations of a ligand to calculate RF-Score features and Vina terms.
	cout.setf(ios::fixed, ios::floatfield);
	cout << setprecision(4 - (score << 1));
	receptor rec;
	rec.load(argv[1 + score]);
	for (ifstream ifs(argv[2 + score]); true;)
	{
		ligand lig;
		lig.load(ifs);
		if (lig.empty()) break;
		const vector<float> v = feature(rec, lig);

		// Filter out the five _intra features.
		assert(v.size() == 47);
		vector<float> x(42);
		for (size_t i = 0; i < x.size() - 1; ++i)
		{
			x[i] = v[i];
		}
		x[x.size() - 1] = v.back();
//		const auto& x = v;

		if (score)
		{
			cout << f(x) << endl;
		}
		else
		{
			cout << x[0];
			for (size_t i = 1; i < x.size(); ++i)
			{
				cout << '\t' << x[i];
			}
			cout << endl;
		}
	}
}
