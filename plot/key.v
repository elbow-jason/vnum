module plot
// Key encapsulates settings for keys/legends in a chart.
// Key placement is governed by Pos which may take the following values:
// otl  otc  otr
// +-------------+          o: outside
// olt |itl  itc  itr| ort      i: inside
// |             |          t: top
// olc |icl  icc  icr| orc      c: centered
// |             |          b: bottom
// olb |ibl  ibc  ibr| orb      l: left
// +-------------+          c: centered
// obl  obc  obr           r: right
struct Key {
pub mut:
	hide    bool // Don't show key/legend if true
	cols    int // Number of colums to use. If <0 fill rows before colums
	border  int // -1: off, 0: std, 1...:other styles
	pos     string // default "" is "itr"
	entries KeyHolder // List of entries in the legend
	x       int
	y       int
}

struct KeyHolder {
pub mut:
	values []KeyEntry
	rows   int
	cols   int
	len    int
}

// KeyEntry encapsulates an antry in the key/legend.
struct KeyEntry {
pub mut:
	text       string // Text to display
	plot_style int // What to show: symbol, line, bar or combination thereof
	style      Style // How to show
}

fn (k &KeyHolder) get(i, j int) KeyEntry {
	return k.values[i * j + i]
}

// // Place layouts the Entries in key in the requested (by key.Cols) matrix format
// fn (key Key) place() KeyHolder {
// // count real entries in num, see if multilines are present in havemlmut
// mut num := 0
// for e in key.entries.values {
// if e.text.len == 0 {
// continue
// }
// num++
// }
// if num == 0 {
// return KeyHolder{}
// }
// mut rowfirst := false
// mut cols := key.cols
// if cols < 0 {
// cols = -cols
// rowfirst = true
// }
// if cols == 0 {
// cols = 1
// }
// if num < cols {
// cols = num
// }
// rows := (num + cols - 1) / cols
// // Prevent empty last columns in the following case where 5 elements are placed
// // columnsfirst into 4 columns
// // Col   0    1    2    3
// // AAA  CCC  EEE
// // BBB  DDD
// if !rowfirst && rows * (cols - 1) >= num {
// cols--
// }
// // Arrays with infos
// mut vals := []KeyEntry
// for i := 0; i < rows * cols; i++ {
// vals << KeyEntry{}
// }
// for i, e in key.entries.values {
// if e.text.len == 0 {
// continue
// }
// mut r := 0
// mut c := 0
// if rowfirst {
// r = i / cols
// c = i % cols
// }
// else {
// c = i / rows
// r = i % rows
// }
// vals[c * r + c] = KeyEntry{
// text: e.text
// style: e.style
// plot_style: e.plot_style
// }
// }
// return KeyHolder{
// values: vals
// cols: cols
// rows: rows
// len: cols
// }
// }
// fn textviewlen(t string) f32 {
// mut length := 0.0
// for i := 0; i < t.len; i++ {
// r := t[i..i + 1]
// if r in CharacterWidth {
// length += CharacterWidth[r]
// }
// else {
// length += 23
// }
// }
// length /= AverageCharacterWidth
// return length
// }
// fn text_dim(t string) (f32,int) {
// lines := t.split('\n')
// mut w := 0.0
// mut h := 0
// for line in lines {
// tvl := textviewlen(line)
// if tvl > w {
// w = tvl
// }
// }
// h = lines.len
// return w,h
// }
// // The following variables control the layout of the key/legend box. // All values are in font-units (fontheight for vertical, fontwidth for horizontal values)
// const (
// KeyHorSep = 1.5 // Horizontal spacing between key box and content
// KeyVertSep = 0.5 // Vertical spacing between key box and content
// KeyColSep = 2.0 // Horizontal spacing between two columns in key
// KeySymbolWidth = 5.0 // Horizontal length/space reserved for symbol
// KeySymbolSep = 2.0 // Horizontal spacing bewteen symbol and text
// KeyRowSep = 0.75 // Vertical spacing between individual rows.
// )
// // layout determines how wide and broad the places keys in m will be rendered.
// fn (key Key) layout(bg Plotter, m &KeyHolder, font Font) (int,int,[]int,[]int) {
// fontwidth,fontheight,_ := bg.font_metrics(font)
// cols := m.cols
// rows := m.rows
// // Find total width and height
// mut totalh := 0
// mut rowheight := [0].repeat(rows)
// for r := 0; r < rows; r++ {
// mut rh := 0
// for c := 0; c < cols; c++ {
// e := m.get(r, c)
// _,h := text_dim(e.text)
// if h > rh {
// rh = h
// }
// }
// rowheight[r] = rh
// totalh += rh
// }
// mut totalw := 0
// mut colwidth := [0].repeat(cols)
// // fmt.Printf("Making totalw for %d cols\n", cols)
// for c := 0; c < cols; c++ {
// mut rw := 0.0
// for r := 0; r < rows; r++ {
// e := m.get(r, c)
// w,_ := text_dim(e.text)
// if w > rw {
// rw = w
// }
// }
// irw := int(rw + 0.75)
// colwidth[c] = irw
// totalw += irw
// // fmt.Printf("Width of col %d: %d.  Total now: %d\n", c, irw, totalw)
// }
// if fontwidth == 1 && fontheight == 1 {
// // totalw/h are characters only and still in character-units
// totalw += int(KeyColSep) * (cols - 1) // add space between columns
// totalw += int(2.0 * KeyHorSep + 0.5) // add space for left/right border
// totalw += int(KeySymbolWidth + KeySymbolSep + 0.5) * cols // place for symbol and symbol-text sep
// totalh += int(KeyRowSep) * (rows - 1) // add space between rows
// mut vsep := KeyVertSep
// if vsep < 1 {
// vsep = 1
// } // make sure there _is_ room (as KeyVertSep < 1)
// totalh += int(2.0 * vsep) // add border at top/bottom
// }
// else {
// // totalw/h are characters only and still in character-units
// totalw = int(f32(totalw) * fontwidth) // scale to pixels
// totalw += int(KeyColSep * (f32(cols - 1) * fontwidth)) // add space between columns
// totalw += int(2.0 * KeyHorSep * fontwidth) // add space for left/right border
// totalw += int((KeySymbolWidth + KeySymbolSep) * fontwidth) * cols // place for symbol and symbol-text sep
// totalh *= fontheight
// totalh += int(KeyRowSep * f32((rows - 1) * fontheight)) // add space between rows
// mut vsep := KeyVertSep * f32(fontheight)
// if vsep < 1 {
// vsep = 1
// } // make sure there _is_ room (as KeyVertSep < 1)
// totalh += int(2.0 * vsep) // add border at top/bottom
// }
// return totalw,totalh,colwidth,rowheight
// }
// // generic_key draws the key onto bg at (x,y).
// fn generic_key(bg Plotter, mx int, my int, key Key, options map[string]Style) {
// m := key.place()
// }
