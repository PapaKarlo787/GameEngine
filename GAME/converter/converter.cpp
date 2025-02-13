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

void preGLA(int* cntMembers, RGB* newCodeBook, vector<RGB>& codeBook, vector<RGB>::const_iterator begin, vector<RGB>::const_iterator end) {
	for (auto it = begin; it != end; it++) {
		int i = findNearestElem(*it, codeBook);
		mtx.lock();
		newCodeBook[i] += *it;
		cntMembers[i]++;
		mtx.unlock();
	}
}

void gla(vector<RGB>& codeBook, vector<RGB> const& colors) {
	RGB newCodeBook[PALETE_SIZE];
	int cntMembers[PALETE_SIZE];
	vector<thread> threads;
	for (int i = 0; i < PALETE_SIZE; i++) {
		newCodeBook[i] = RGB();
		cntMembers[i] = 0;
	}
	int bucketSize = colors.size() / BUCKET_CNT;
	
	for (int i = 0; i < GLA_STEPS; i++) {
		for (int i = 0; i < BUCKET_CNT; i++) {
			auto bucketBegin = colors.begin() + i * bucketSize;
			//preGLA(cntMembers, newCodeBook, codeBook, bucketBegin, bucketBegin + bucketSize);
			threads.push_back(thread(preGLA, cntMembers, newCodeBook, ref(codeBook), bucketBegin, bucketBegin + bucketSize));
		}
		preGLA(cntMembers, newCodeBook, codeBook, colors.begin() + bucketSize * BUCKET_CNT, colors.end());
		for (auto& th : threads) {
			th.join();
		}
		threads.clear();
		for (int i = 0; i < PALETE_SIZE; i++) {
			codeBook[i] = cntMembers[i] ? newCodeBook[i] / cntMembers[i] : RGB();
			newCodeBook[i] = RGB();
			cntMembers[i] = 0;
		}
	}
}

void medianCut(vector<RGB>& result, vector<RGB>::iterator begin, vector<RGB>::iterator end, int floor) {
	static function<bool(RGB const&, RGB const&)> r = [](RGB const& a, RGB const& b) {return a.r < b.r; };
	static function<bool(RGB const&, RGB const&)> g = [](RGB const& a, RGB const& b) {return a.g < b.g; };
	static function<bool(RGB const&, RGB const&)> b = [](RGB const& a, RGB const& b) {return a.b < b.b; };
	static auto vSizePred = [](vector<RGB>* a, vector<RGB>* b) {return a->size() < b->size(); };
	vector<thread> threads;
	
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
			//medianCut(ref(result), begin + m, end, i);
			threads.push_back(thread(medianCut, ref(result), begin + m, end, i));
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
	for (auto& th : threads) {
		th.join();
	}
}


int main(int n, const char** args) {
	vector<RGB> colors;
	vector<File> files;
	vector<RGB> codeBook;

	if (n < 3 || strcmp(args[1], "-o")) {
		cerr << "invalid usage\nusage: " << args[0] << " -o filename [file.bmp [...]]" << endl;
		return -1;
	}

	getColors(n - 3, args + 3, colors, files);
	medianCut(codeBook, colors.begin(), colors.end(), 8);
	gla(codeBook, colors);

	for(auto color : colors) {
		int ind = findNearestElem(color, codeBook);
		color.f->addResData(ind, color.pos);
	}

	int fd = open(args[2], O_WRONLY | O_CREAT | O_TRUNC, 0777);
	writeCodeBook(fd, codeBook);
	uint16_t backs_cnt = 0;
	for (auto &f : files) {
		backs_cnt += f.is_back();
	}
	uint16_t sprites_cnt = files.size() - backs_cnt;
	err += write(fd, &backs_cnt, sizeof(backs_cnt));
	err += write(fd, &sprites_cnt, sizeof(sprites_cnt));
	for (auto &f : files) {
		if (f.is_back())
			writef(fd);
	}
	for (auto &f : files) {
		if (!f.is_back())
			writef(fd);
	}
	return 0;
}
