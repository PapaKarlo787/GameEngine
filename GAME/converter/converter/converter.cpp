#include <iostream>
#include <set>
#include <vector>
#include <map>
#include <algorithm>
#include <functional>
#include <numeric>
#include "rgb.h"
#include "helper.h"

using namespace std;

vector<RGB> collectRepresentors(vector<vector<RGB>>& sets) {
	vector<RGB> represes;
	for (const auto& s : sets) {
		RGB sum = accumulate(s.begin(), s.end(), RGB());
		represes.push_back(s.size() ? sum / s.size() : RGB());
	}
	return represes;
}

void writeRepreses(int fd, vector<RGB> represes) {
	char data[256 * 3];
	for (int i = 0; i < represes.size(); i++) {
		data[i * 3 + 0] = represes[i].r;
		data[i * 3 + 1] = represes[i].g;
		data[i * 3 + 2] = represes[i].b;
	}
}

void gla(vector<vector<RGB>>& sets, vector<RGB>& colors) {
	vector<RGB> represes = collectRepresentors(sets);
	map<RGB, vector<RGB>> tmpSets;
	for (auto& color : colors) {
		uint32_t dist = -1;
		RGB repres;
		for (auto& rep : represes) {
			uint32_t d = color.dist(rep);
			if (dist > d) {
				dist = d;
				repres = rep;
			}
		}
		if (tmpSets.count(repres)) {
			tmpSets[repres].push_back(color);
		}
		else {
			tmpSets[repres] = vector<RGB>{ color };
		}
	}
	sets.clear();
	for (auto const& s : tmpSets) {
		sets.push_back(s.second);
	}
}

void medianCut(set<vector<RGB>>& colorSets) {
	function<bool(RGB const&, RGB const&)> r = [](RGB const& a, RGB const& b) {return a.r < b.r; };
	function<bool(RGB const&, RGB const&)> g = [](RGB const& a, RGB const& b) {return a.g < b.g; };
	function<bool(RGB const&, RGB const&)> b = [](RGB const& a, RGB const& b) {return a.b < b.b; };
	auto vSizePred = [](vector<RGB> a, vector<RGB> b) {return a.size() < b.size(); };

	for (int i = 0; i < 255; i++) {
		vector<RGB> curSet = *max_element(colorSets.begin(), colorSets.end(), vSizePred);
		colorSets.erase(curSet);
		uint32_t m = max_element(begin(curSet), end(curSet), r) - min_element(begin(curSet), end(curSet), r);
		function<bool(RGB const&, RGB const&)> comp = r;
		for (auto f : { g, b }) {
			auto s = max_element(begin(curSet), end(curSet), f) - min_element(begin(curSet), end(curSet), f);
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


int main(int n, const char** args) {
	vector<RGB> colors;
	vector<File> files;

	if (n < 3 || strcmp(args[1], "-o")) {
		cerr << "invalid usage\nusage: " << args[0] << " -o filename [file.bmp [...]]" << endl;
		return -1;
	}

	getColors(n - 3, args + 3, colors, files);

	set<vector<RGB>> colorSets{ colors };
	medianCut(colorSets);

	vector<vector<RGB>> colorGroups;
	colorGroups.reserve(colorSets.size());
	move(colorSets.begin(), colorSets.end(), back_inserter(colorGroups));
	for (int i = 0; i < 100; i++) {
		gla(colorGroups, colors);
	}

	for (int i = 0; i < colorGroups.size(); i++) {
		for (auto color : colorGroups[i]) {
			color.f->addResData(i, color.pos);
		}
	}
	vector<RGB> finalRepreses = collectRepresentors(colorGroups);

	int fd = _open(args[1], _O_WRONLY);
	writeRepreses(fd, finalRepreses);
	uint16_t size = files.size();
	_write(fd, &size, sizeof(size));
	for (auto f : files) {
		f.write(fd);
	}

	return 0;
}
