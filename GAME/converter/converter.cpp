#include <iostream>
#include <thread>
#include <mutex>
#include <stdint.h>
#include <functional>
#include <numeric>

uint32_t err;
#include "rgb.h"
#include "file.h"

#define GLA_STEPS 8
#define BUCKET_CNT 8
#define PALETE_SIZE 256

using namespace std;
mutex mtx;

void writeCodeBook(int fd, vector<RGB>& codeBook) {
	char data[256 * 3];
	for (int i = 0; i < PALETE_SIZE; i++) {
		data[i * 3 + 0] = codeBook[i].r;
		data[i * 3 + 1] = codeBook[i].g;
		data[i * 3 + 2] = codeBook[i].b;
	}
	err += write(fd, data, sizeof(data));
}

inline int findNearestElem(RGB const& color, vector<RGB> const& codeBook) {
	int result = 0;
	uint32_t dist = -1;
	for (int i = 0; i < PALETE_SIZE; i++) {
		uint32_t d = color.dist(codeBook[i]);
		if (dist > d) {
			dist = d;
			result = i;
		}
	}
	return result;
}

template<typename T>
void preGLA(int* cntMembers, RGB* newCodeBook, T const& codeBook, T::iterator& begin, T::iterator& end) {
	for (auto it = begin; it != end; it++) {
		int i = findNearestElem(*it, codeBook);
		mtx.lock();
		CodeBook[i] += color;
		cntMembers[i]++;
		mtx.unlock();
	}
}

void gla(vector<RGB>& codeBook, vector<RGB> const& colors) {
	RGB newCodeBook[PALETE_SIZE];
	int cntMembers[PALETE_SIZE];
	vector<thread> treads;
	for (int i = 0; i < PALETE_SIZE; i++) {
		newCodeBook[i] = RGB();
		cntMembers[i] = 0;
	}
	int bucketSize = colors.size() / BUCKET_CNT;
	
	for (int i = 0; i < GLA_STEPS; i++) {
		for (int i = 0; i < BUCKET_CNT; i++) {
			auto bucketBegin = colors.begin() + i * bucketSize;
			treads.push_back(thread(preGLA, cntMembers, newCodeBook, bucketBegin, bucketBegin + bucketSize));
		}
		preGLA(cntMembers, newCodeBook, bucketSize * BUCKET_CNT, colors.end());
		for (auto const& th : treads) {
			th.join();
		}
		for (int i = 0; i < PALETE_SIZE; i++) {
			codeBook[i] = cntMembers[i] ? newCodeBook[i] / cntMembers[i] : RGB();
			newCodeBook[i] = RGB();
			cntMembers[i] = 0;
		}
	}
}

template<typename T>
RGB medianCut(T& result, T::iterator& begin, T::iterator& end, int floor) {
	static function<bool(RGB const&, RGB const&)> r = [](RGB const& a, RGB const& b) {return a.r < b.r; };
	static function<bool(RGB const&, RGB const&)> g = [](RGB const& a, RGB const& b) {return a.g < b.g; };
	static function<bool(RGB const&, RGB const&)> b = [](RGB const& a, RGB const& b) {return a.b < b.b; };
	static auto vSizePred = [](vector<RGB>* a, vector<RGB>* b) {return a->size() < b->size(); };
	vector<thread> treads;
	
	for (int i = floor - 1; i >= 0; i--) {
		uint32_t m = max_element(begin, end, r) - min_element(begin, end, r);
		function<bool(RGB const&, RGB const&)> comp = r;
		for (auto f : { g, b }) {
			auto s = max_element(begin, end, f) - min_element(begin, end, f);
			if (m > s) {
				m = s;
				comp = f;
			}
		}
		sort(begin, end, comp);
		int size = end - begin;
		m = size / 2;
		if (i) {
			treads.push_back(thread(mediancut, result, begin + m, end, i));
			end = begin + m;
		} else {
			RGB res1, res2;
			if (size) {
				res1 = accumulate(begin, end - m, RGB()) / size;
				res2 = accumulate(begin + m, end, RGB()) / size;
			}
			mtx.lock();
			result.push_back(res1);
			result.push_back(res2);
			mtx.unlock();
		}
	}
	for (int i = 0; i < floor - 1; i++) {
		threads[i].join();
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
	vector<RGB> codeBook;
	medianCut(codeBook, colors.begin(), colors.end(), 8);
	gla(codeBook, colors);

	for(auto color : colors) {
		int ind = findNearestElem(color, codeBook);
		color.f->addResData(ind, color.pos);
	}

	int fd = open(args[2], O_WRONLY | O_CREAT | O_TRUNC, 0777);
	uint16_t size = files.size();
	err += write(fd, &size, sizeof(size));
	writeCodeBook(fd, codeBook);
	for (int i = 0; i < size; i++) {
		files[i].writef(fd);
	}
	return 0;
}
