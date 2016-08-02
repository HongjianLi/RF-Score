#include <iostream>
#include <iomanip>
#include <string>
#include <vector>
#include <numeric>
#include <algorithm>
#include <cmath>
using namespace std;

float pearson(const vector<float>& y, const vector<float>& x)
{
	const size_t n = y.size();
	float x1sum = 0, y1sum = 0, x2sum = 0, y2sum = 0, xysum = 0;
	for (size_t i = 0; i < n; ++i)
	{
		x1sum += x[i];
		y1sum += y[i];
		x2sum += x[i] * x[i];
		y2sum += y[i] * y[i];
		xysum += x[i] * y[i];
	}
	return (n*xysum-x1sum*y1sum)/sqrt((n*x2sum-x1sum*x1sum)*(n*y2sum-y1sum*y1sum));
	// Another calculation is suggested in a JCIM article titled "Beware of R2: Simple, Unambiguous Assessment of the Prediction Accuracy of QSAR and QSPR Models" by Alexander, D. L. J. and Tropsha, A. and Winkler, David A.
/*	float y1sum = 0;
	for (size_t i = 0; i < n; ++i)
	{
		y1sum += y[i];
	}
	float nu = 0, de = 0;
	for (size_t i = 0; i < n; ++i)
	{
		const float ny = n * y[i];
		const float nt = (ny - n * x[i]);
		const float dt = (ny - y1sum);
		nu += nt * nt;
		de += dt * dt;
	}
	return sqrt(1 - nu / de);*/
}

float spearman(const vector<float>& y, const vector<float>& x)
{
	const size_t n = y.size();
	vector<size_t> xcase(n), ycase(n);
	iota(xcase.begin(), xcase.end(), 0);
	iota(ycase.begin(), ycase.end(), 0);
	sort(xcase.begin(), xcase.end(), [&x](size_t val1, size_t val2)
	{
		return x[val1] < x[val2];
	});
	sort(ycase.begin(), ycase.end(), [&y](size_t val1, size_t val2)
	{
		return y[val1] < y[val2];
	});
	vector<float> xrank(n), yrank(n);
	for (size_t i = 0, j; i < n;)
	{
		for (j = i + 1; j < n && x[xcase[j]] == x[xcase[i]]; ++j);
		const float r = (i + j + 1) * 0.5f;
		for (; i < j; xrank[xcase[i++]] = r);
	}
	for (size_t i = 0, j; i < n;)
	{
		for (j = i + 1; j < n && y[ycase[j]] == y[ycase[i]]; ++j);
		const float r = (i + j + 1) * 0.5f;
		for (; i < j; yrank[ycase[i++]] = r);
	}
	return pearson(yrank, xrank);
}

template <typename T>
inline int sgn(T x)
{
	return (static_cast<T>(0) < x) - (x < static_cast<T>(0));
}

float kendall(const vector<float>& y, const vector<float>& x)
{
	const size_t n = y.size();
	float numer = 0;
	for (size_t i = 0; i < n - 1; ++i)
	{
		for (size_t j = i + 1; j < n; ++j)
		{
		    numer += sgn(x[i] - x[j]) * sgn(y[i] - y[j]);
		}
	}
	return numer / (0.5 * n * (n-1));
}

int main(int argc, char* argv[])
{
	// Parse y and x from cin.
	vector<float> y, x;
	y.reserve(100);
	x.reserve(100);
	for (string line; getline(cin, line);)
	{
		size_t c = line.find(',');
		y.push_back(stof(line.substr(0, c)));
		x.push_back(stof(line.substr(c + 1)));
	}

	// Compute a and b for lm(y ~ x)
	const size_t n = y.size();
	float x1sum = 0, y1sum = 0, x2sum = 0, xysum = 0;
	for (size_t i = 0; i < n; ++i)
	{
		x1sum += x[i];
		y1sum += y[i];
		x2sum += x[i] * x[i];
		xysum += x[i] * y[i];
	}
	const float b = (n*xysum-x1sum*y1sum)/(n*x2sum-x1sum*x1sum);
	const float a = (y1sum-b*x1sum)/n;

	// Compute rmse, sdev, pcor, scor, kcor.
	float se2p = 0, se2r = 0;
	for (size_t i = 0; i < n; ++i)
	{
		const float p = x[i];
		const float r = a + b * p;
		se2p += (p - y[i]) * (p - y[i]);
		se2r += (r - y[i]) * (r - y[i]);
	}
	const auto rmse = sqrt(se2p / n);
	const auto sdev = sqrt(se2r / (n - 2));
	const auto pcor = pearson(y, x);
	const auto scor = spearman(y, x);
	const auto kcor = kendall(y, x);

	// Write statistics.
	cout.setf(ios::fixed, ios::floatfield);
	cout << "n,rmse,sdev,pcor,scor,kcor" << endl << n << ',' << setprecision(2) << rmse << ',' << sdev << ',' << setprecision(3) << pcor << ',' << scor << ',' << kcor << endl;
}
