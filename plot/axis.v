module plot

struct AxisOptions {
pub mut:
	text 	TextOptions
	range 	Range
	title	string
	num_tics	int = 5
	tic_settings	TicSettings
	hide	bool
}

fn (ao AxisOptions) info(size int) (int, f64, f64, f64) {	
	return ao.num_tics, f64(size) / (ao.num_tics - 1), ao.range.min, (ao.range.max - ao.range.min) / (ao.num_tics - 1)
}

fn fmt(f f64) string {
	buf := malloc(8 * 5 + 1) // TODO
	C.sprintf(charptr(buf), '%.1f', f)
	return tos(buf, vstrlen(buf))
}

struct TicSettings {
mut:
	length	int = 5
	width	int = 2
	color	Color
	grid_color 	Color
	grid_linewidth	int = 	1
}

fn new_tic_setting() TicSettings {
	mut tc := TicSettings{}
	tc.color = BLACK
	tc.grid_color = OPAQUE
	tc.length = 5
	tc.width = 2
	return tc
}

fn new_axis() AxisOptions {
	mut ao := AxisOptions{}
	ao.tic_settings = new_tic_setting()
	ao.text = new_text_options()
	ao.num_tics = 5
	return ao
}

fn (axis AxisOptions) unbounded() bool {
	return axis.range.min == axis.range.max
}

