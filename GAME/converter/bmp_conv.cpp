#include <iostream>
#include <set>
#include <vector>
#include <map>
#include <algorithm>
#include "rgb.h"

using namespace std;

void gla(vector<vector<RGB>>& sets, vector<RGB> const& colors) {
	vector<RGB> represes;
	for (auto const& s : sets) {
		RGB srgb;
		for (auto const& rgb : s) {
			srgb += rgb;
		}
		represes.push_back(srgb / s.size());
	}
	map<RGB, vector<RGB>> tmpSets;
	for (auto const& color : colors) {
		uint32_t dist = -1;
		RGB repres;
		for (auto const& rep : represes) {
			uint32_t d = color.dist(rep);
			if (dist > d) {
				dist = d;
				repres = rep;
			}
		}
		if (tmpSets.contains(repres)) {
			tmpSets[repres].push_back(color);
		} else {
			tmpSets[repres] = vector<RGB>{color};
		}
	}
	sets.clear();
	for (auto const& s : tmpSets) {
		sets.push_back(s.second);
	}
}

void medianCut(set<vector<RGB>>& colorSets) {
	auto r = [](RGB const& a, RGB const& b) {return a.r < b.r;};
	auto g = [](RGB const& a, RGB const& b) {return a.g < b.g;};
	auto b = [](RGB const& a, RGB const& b) {return a.b < b.b;};

	for (int i = 0; i < 255; i++) {
		vector<RGB>& curSet = max(colorSets, [](auto const& a, auto const& b){return a.size() < b.size();});
		colorSets.erase(curSet);
		uint32_t m = max(curSet, r) - min(curSet, r);
		auto comp = r;
		for (auto f : {g, b}) {
			auto s = max(curSet, f) - min(curSet, f);
			if (m > s) {
				m = s;
				comp = f;
			}
		}
		sort(curSet.begin(), curSet.end(), comp);
		m = curSet.size() / 2;
		colorSets.insert(vector<RGB>(curSet.begin(), curSet.end() - m));
		colorSets.insert(vector<RGB>(curSet.begin() + m, curSet.end()));
	}
}


int main(int n, char** args) {
	
}
