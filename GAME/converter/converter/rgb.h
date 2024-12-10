#pragma once
class File;

class RGB {
public:
	RGB(int64_t r_ = 0, int64_t g_ = 0, int64_t b_ = 0) {
		r = r_;
		g = g_;
		b = b_;
		f = 0;
		pos = 0;
	}

	RGB(uint8_t rgb[3], File* f_ = 0, uint32_t pos_ = 0) {
		r = rgb[0];
		g = rgb[1];
		b = rgb[2];
		pos = pos_;
		f = f_;
	}

	RGB operator+(RGB const& other) const {
		return RGB(r + other.r, g + other.g, b + other.b);
	}

	RGB operator-(RGB const& other) {
		return RGB(r - other.r, g - other.g, b - other.b);
	}

	RGB operator/(uint32_t other) {
		return RGB(r / other, g / other, b / other);
	}

	uint32_t operator*(RGB const& other) const {
		return this->r * other.r + this->g * other.g + this->b * other.b;
	}

	bool operator<(RGB const& other) const {
		return (*this)* (*this) < other* other;
	}

	uint32_t dist(RGB& other) {
		return (*this - other) * (*this - other);
	}

	File* f;
	int64_t r, g, b;
	uint32_t pos;
};
