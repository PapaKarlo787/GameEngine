import math
import sys
import imageio.v3 as iio

if __name__ == "__main__":
	for fn in sys.argv[1:]:
		res = []
		im = iio.imread(fn)
		h, w, c = im.shape
		im.shape = (10, 20, 30)
		print(im.shape)
		res.append(h & 255)
		res.append(h >> 8)
		res.append(w & 255)
		res.append(h >> 8)
		for i in range(h):
			for l in range(w):
				res.append(int(im[i][l][0]))
				res.append(int(im[i][l][1]))
				res.append(int(im[i][l][2]))
		with open(".".join(fn.split(".")[:-1]) + ".pmb", 'wb') as f:
			f.write(bytes(res))
