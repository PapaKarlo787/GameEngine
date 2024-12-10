import sys
from PIL import Image

def read_colors(f):
	res = []
	for i in range(256):
		res.append(tuple(f.read(3)))
	return res

def get_short(d):
	return d[0] + (d[1] << 8)

if __name__ == "__main__":
	if len(sys.argv) < 2:
		raise Exception("usage: {} packagename".fromat(sys.argv[0]))
	with open(sys.argv[1], 'rb') as f:
		palete = read_colors(f)
		s = get_short(f.read(2))
		data = []
		for i in range(s):
			h = get_short(f.read(2))
			w = get_short(f.read(2))
			for l in range(h * w):
				data.append(palete[f.read(1)[0]])
			image = Image.new('RGB', (w, h))
			image.putdata(data)
			image.save('{}.bmp'.format(i))
