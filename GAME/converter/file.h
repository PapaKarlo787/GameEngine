#pragma once
#pragma warning(disable : 4996)

#include <unistd.h>
#include <stdint.h>
#include <fcntl.h>
#include <cstring>
#include "rgb.h"


using namespace std;

class File {
public:
	File(const char* fn_) {
		size_t size = strlen(fn_) + 5;
		fdr = open(fn_, O_RDONLY);
		h = w = 0;
		err += read(fdr, &h, 2);
		err += read(fdr, &w, 2);
		data = (char*)malloc(h * w);
	}

	File(const File& other) {
		fdr = other.fdr;
		h = other.h;
		w = other.w;
		data = (char*)malloc(h * w);
	}

	~File(){
		free(data);
	}

	uint32_t getDataSize() {
		return h * w;
	}

	void addResData(uint8_t palInd, uint32_t pos) {
		data[pos] = palInd;
	}

	void writef(int fd) {
		err += write(fd, &h, 2);
		err += write(fd, &w, 2);
		err += write(fd, data, h * w);
	}

	void readf(vector<RGB>& res) {
		uint8_t data[h * w * 3];
		err += read(fdr, data, sizeof(data));
		for (uint32_t i = 0; i < h * w; i++) {
			res.push_back(RGB(&data[i * 3], this, i));
		}
	}
	
	bool is_back() {
		return h == 200 && w == 320;
	}
	
private:
	uint32_t h, w;
	int fdr;
	char *data;
};

void getColors(int n, const char** fns, vector<RGB>& res, vector<File>& resf) {
	uint32_t total_size = 0;
	for (int i = 0; i < n; i++) {
		resf.push_back(File(fns[i]));
		total_size += resf.back().getDataSize();
	}
	res.reserve(total_size);
	for (auto& f : resf) {
		f.readf(res);
	}
}
