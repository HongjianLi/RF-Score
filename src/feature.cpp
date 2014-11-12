#include "scoring_function.hpp"
#include "feature.hpp"

vector<float> feature(const receptor& rec, const ligand& lig, const size_t model)
{
	static const scoring_function sf;
	vector<float> v(model == 4 ? 47 : (model == 3 ? 11 : 12)); // 36 RF-Score features, 5 Vina features from e_inter, 5 Vina features from e_intra, and 1 Vina feature from Nrot.
	const size_t offsetr = model == 4 ? 36 : 0;
	for (const auto& l : lig)
	{
		for (const auto& r : rec)
		{
			const float d0 = l.coord[0] - r.coord[0];
			const float d1 = l.coord[1] - r.coord[1];
			const float d2 = l.coord[2] - r.coord[2];
			const float ds = d0 * d0 + d1 * d1 + d2 * d2;
			if (model == 4)
			{
				if (ds >= 144) continue; // RF-Score cutoff 12A
				if (!l.rf_unsupported() && !r.rf_unsupported())
				{
					++v[(l.rf << 2) + r.rf];
				}
			}
			if (ds >= 64) continue; // Vina score cutoff 8A
			if (!l.xs_unsupported() && !r.xs_unsupported())
			{
				sf.score(v.data() + offsetr, l.xs, r.xs, ds);
			}
		}
	}
	const size_t offseta = offsetr + 5;
	for (const auto& ip : lig.interacting_pairs)
	{
		const auto& a0 = lig[ip.i0];
		const auto& a1 = lig[ip.i1];
		const float d0 = a0.coord[0] - a1.coord[0];
		const float d1 = a0.coord[1] - a1.coord[1];
		const float d2 = a0.coord[2] - a1.coord[2];
		const float ds = d0 * d0 + d1 * d1 + d2 * d2;
		if (ds >= 64) continue; // Vina score cutoff 8A
		if (!a0.xs_unsupported() && !a1.xs_unsupported())
		{
			sf.score(v.data() + offseta, a0.xs, a1.xs, ds);
		}
	}
	if (model == 2)
	{
		v[10] = lig.num_active_torsions;
		v[11] = lig.num_inactive_torsions;
	}
	else
	{
		v.back() = 1 / (1 + /*0.05846f **/ (lig.num_active_torsions + 0.5f * lig.num_inactive_torsions)); // Both idock executable and daemon use lig.flexibility_penalty as the last feature, so wNrot should be uncommented.
	}
//	sf.weight(v.data() + 36); // The 5 Vina terms are now weighted.
	return v;
}
