#pragma once
#pragma warning(disable : 4996)

#include <io.h>
#include <vector>
#include <fcntl.h>
#include <cstring>
#include "rgb.h"


using namespace std;

class File {
public:
	File(const char* fn_) {
		size_t size = strlen(fn_) + 5;
		fdr = _open(fn_, _O_RDONLY);
		_read(fdr, &h, sizeof(h));
		_read(fdr, &w, sizeof(w));
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

	void write(int fd) {
		_write(fd, &h, 2);
		_write(fd, &w, 2);
		_write(fd, data, h * w);
	}

	void read(vector<RGB>& res) {
		for (uint32_t i = 0; i < h * w; i++) {
			uint8_t data[3];
			_read(fdr, data, sizeof(data));
			res.push_back(RGB(data, this, i));
		}
	}

private:
	uint32_t h, w;
	int fdr;
	char *data;
};

void getColors(int n, const char** fns, vector<RGB>& res, vector<File>& resf) {
	for (int i = 0; i < n; i++) {
		auto f = File(fns[i]);
		resf.push_back(f);
		f.read(res);
	}
}
