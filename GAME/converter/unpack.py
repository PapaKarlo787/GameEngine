import sys
from PIL import Image

def read_colors(f):
	res = []
	for i in range(256):
		res.append(tuple(f.read(3)))
	return res

indexes = [0]*256

def get_short(d):
	return d[0] + (d[1] << 8)

if __name__ == "__main__":
	if len(sys.argv) < 2:
		raise Exception("usage: {} packagename".fromat(sys.argv[0]))
	with open(sys.argv[1], 'rb') as f:
		s = get_short(f.read(2))
		palete = read_colors(f)
		data = []
		print(s)
		for i in range(s):
			h = get_short(f.read(2))
			w = get_short(f.read(2))
			print(h, w)
			for l in range(h * w):
				i = f.read(1)[0]
				indexes[i] += 1
				data.append(palete[i])
			image = Image.new('RGB', (w, h))
			image.putdata(data)
			image.save('{}.bmp'.format(i))
