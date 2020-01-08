module plot

const (
	Symbol = ['o', // empty circle
	'=', // empty square
	'%', // empty triangle up
	'&', // empty diamond
	'+', // plus
	'X', // cross
	'*', // star
	'0', // bulls eys
	'@', // filled circle
	'#', // filled square
	'A', // filled triangle up
	'W', // filled triangle down
	'V', // empty triangle down
	'Z', // filled diamond
	'.', // tiny dot
	]
	CharacterWidth = {
		'a': 16.8,
		'b': 17.0,
		'c': 15.2,
		'd': 16.8,
		'e': 16.8,
		'f': 8.5,
		'g': 17.0,
		'h': 16.8,
		'i': 5.9,
		'j': 5.9,
		'k': 16.8,
		'l': 6.9,
		'm': 25.5,
		'n': 16.8,
		'o': 16.8,
		'p': 17.0,
		'q': 17.0,
		'r': 10.2,
		's': 15.2,
		't': 8.4,
		'u': 16.8,
		'v': 15.4,
		'w': 22.2,
		'x': 15.2,
		'y': 15.2,
		'z': 15.2,
		'A': 20.2,
		'B': 20.2,
		'C': 22.2,
		'D': 22.2,
		'E': 20.2,
		'F': 18.6,
		'G': 23.5,
		'H': 22.0,
		'I': 8.2,
		'J': 15.2,
		'K': 20.2,
		'L': 16.8,
		'M': 25.5,
		'N': 22.0,
		'O': 23.5,
		'P': 20.2,
		'Q': 23.5,
		'R': 21.1,
		'S': 20.2,
		'T': 18.5,
		'U': 22.0,
		'V': 20.2,
		'W': 29.0,
		'X': 20.2,
		'Y': 20.2,
		'Z': 18.8,
		' ': 8.5,
		'1': 16.8,
		'2': 16.8,
		'3': 16.8,
		'4': 16.8,
		'5': 16.8,
		'6': 16.8,
		'7': 16.8,
		'8': 16.8,
		'9': 16.8,
		'0': 16.8,
		'.': 8.2,
		',': 8.2,
		':': 8.2,
		';': 8.2,
		'+': 17.9,
		'\"': 11.0,
		'*': 11.8,
		'%': 27.0,
		'&': 20.2,
		'/': 8.4,
		'(': 10.2,
		')': 10.2,
		'=': 18.0,
		'?': 16.8,
		'!': 8.5,
		'[': 8.2,
		']': 8.2,
		'{': 10.2,
		'}': 10.2,
		'$': 16.8,
		'<': 18.0,
		'>': 18.0,
		'§': 16.8,
		'°': 12.2,
		'^': 14.2,
		'~': 18.0
	}
	AverageCharacterWidth = 15
)

fn symbol_index(s string) int {
	for idx := 0; idx < Symbol.len; idx++ {
		if Symbol[idx] == s {
			return idx
		}
	}
	return -1
}

fn next_symbol(s string) string {
	idx := symbol_index(s)
	return Symbol[(idx + 1) % Symbol.len]
}
