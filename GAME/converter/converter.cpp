#include <iostream>
#include <set>
#include <stdint.h>
#include <functional>
#include <numeric>

uint32_t err;
#include "rgb.h"
#include "file.h"

#define GLA_STEPS 8
#define PALETE_SIZE 256

using namespace std;

void writeRepreses(int fd, vector<RGB>& represes) {
	char data[256 * 3];
	for (int i = 0; i < PALETE_SIZE; i++) {
		data[i * 3 + 0] = represes[i].r;
		data[i * 3 + 1] = represes[i].g;
		data[i * 3 + 2] = represes[i].b;
	}
	err += write(fd, data, sizeof(data));
}

inline int findNearestRepresentor(RGB const& color, vector<RGB> const& representors) {
	int result = 0;
	uint32_t dist = -1;
	for (int i = 0; i < PALETE_SIZE; i++) {
		uint32_t d = color.dist(representors[i]);
		if (dist > d) {
			dist = d;
			result = i;
		}
	}
	return result;
}

void gla(vector<RGB>& represes, vector<RGB> const& colors) {
	RGB newRepreses[PALETE_SIZE];
	int cntMembers[PALETE_SIZE];
	for (int i = 0; i < PALETE_SIZE; i++) {
		newRepreses[i] = RGB();
		cntMembers[i] = 0;
	}
	for (int i = 0; i < GLA_STEPS; i++) {
		for (auto& color : colors) {
			int i = findNearestRepresentor(color, represes);
			newRepreses[i] += color;
			cntMembers[i]++;
		}
		for (int i = 0; i < PALETE_SIZE; i++) {
			represes[i] = cntMembers[i] ? newRepreses[i] / cntMembers[i] : RGB();
			newRepreses[i] = RGB();
			cntMembers[i] = 0;
		}
	}
}

void medianCut(set<vector<RGB>*>& colorSets) {
	function<bool(RGB const&, RGB const&)> r = [](RGB const& a, RGB const& b) {return a.r < b.r; };
	function<bool(RGB const&, RGB const&)> g = [](RGB const& a, RGB const& b) {return a.g < b.g; };
	function<bool(RGB const&, RGB const&)> b = [](RGB const& a, RGB const& b) {return a.b < b.b; };
	auto vSizePred = [](vector<RGB>* a, vector<RGB>* b) {return a->size() < b->size(); };

	for (int i = 0; i < PALETE_SIZE - 1; i++) {
		vector<RGB>* curSet = *max_element(colorSets.begin(), colorSets.end(), vSizePred);
		colorSets.erase(curSet);
		uint32_t m = max_element(curSet->begin(), curSet->end(), r) - min_element(curSet->begin(), curSet->end(), r);
		function<bool(RGB const&, RGB const&)> comp = r;
		for (auto f : { g, b }) {
			auto s = max_element(curSet->begin(), curSet->end(), f) - min_element(curSet->begin(), curSet->end(), f);
			if (m > s) {
				m = s;
				comp = f;
			}
		}
		sort(curSet->begin(), curSet->end(), comp);
		m = curSet->size() / 2;
		colorSets.insert(new vector<RGB>(curSet->begin(), curSet->end() - m));
		colorSets.insert(new vector<RGB>(curSet->begin() + m, curSet->end()));
		delete curSet;
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
	set<vector<RGB>*> colorSets{ new vector<RGB>(colors.begin(), colors.end()) };
	medianCut(colorSets);

	vector<RGB> represes;
	for (auto& s : colorSets) {
		RGB sum = accumulate(s->begin(), s->end(), RGB());
		represes.push_back(s->size() ? sum / s->size() : RGB());
		delete s;
	}
	gla(represes, colors);

	for(auto color : colors) {
		int ind = findNearestRepresentor(color, represes);
		color.f->addResData(ind, color.pos);
	}

	int fd = open(args[2], O_WRONLY | O_CREAT | O_TRUNC, 0777);
	uint16_t size = files.size();
	err += write(fd, &size, sizeof(size));
	writeRepreses(fd, represes);
	for (int i = 0; i < size; i++) {
		files[i].writef(fd);
	}
	return 0;
}
