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
		palete = read_colors(f)
		sb = get_short(f.read(2))
		ss = get_short(f.read(2))
		print(sb+ss)
		for i in range(sb+ss):
			h, w = (get_short(f.read(2)), get_short(f.read(2))) if i >= sb else (200, 320)
			data = []
			print(h, w)
			for l in range(h * w):
				data.append(palete[f.read(1)[0]])
			image = Image.new('RGB', (w, h))
			image.putdata(data)
			image.save('{}.bmp'.format(i))
