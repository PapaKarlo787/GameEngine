import math

class RGB:
	def __init__(self, r, g, b, file_data = None):
		self.r = r
		self.g = g
		self.b = b
		self.data = file_data

	def __add__(self, other):
		return RGB(self.r + other.r, self.g + other.g, self.b + other.b)

	def __div__(self, other):
		if not isinstance(other, int):
			raise ArithmeticError("non scalar div")
		return RGB(self.r / other, self.g / other, self.b / other)

	def dist(self, other):
		return math.sqrt(self.r * other.r + self.g * other.g + self.b * other.b)


def get_num(buf, s = False):
	res = 0
	for i in range(len(buf)):
		res |= buf[i] << (i << 3)
	return res

def get_colors(fns):
	colors = []
	for fn in fns:
		with open(fn, 'rb') as f:
			pass
	return colors
	

def get_side(colors):
	max_val = 0
	for comp in [lambda x: x.r, lambda x: x.g, lambda x: x.b]
		val = max(colors, comp) - min(colors, comp)
		if val >= max_val:
			max_val = val
			result = comp
	return result

def GLA(sets, colors):
	represes = map(sets, lambda s: sum(s) / len(s))
	tmp_sets = {}
	for color in colors:
		repres = min(map(represes, color.dist))
		if repres in sets:
			sets[repres].append(color)
		else:
			sets[repres] = [color]
	return tmp_sets.values()

def MC(color_sets):
	for i in range(255):
		cur_set = max(color_sets, len)
		color_sets.remove(cur_set)
		cur_set.sort(key = get_side(cur_set))
		color_sets.add(cur_set[:len(cur_set)/2])
		color_sets.add(cur_set[len(cur_set)/2:])


if __name__ == "__main__":
	colors = get_colors(filenames)
	sets = MC(set([colors]))
	for i in range(100):
		sets = GLA(sets, colors)
	collect_files(sets)
