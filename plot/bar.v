module plot

import vnum.ndarray

struct BarData {
pub mut:
	name	string
	style	Style
	data 	ndarray.NdArray
}