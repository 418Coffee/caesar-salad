module main

import math
import encoding.utf8

fn shift(text []rune, shift int, lo rune, mod int) []rune {
	mut copy := []rune{cap: text.len}
	for r in text {
		if !utf8.is_letter(r) {
			copy << r
			continue
		}
		copy << lo + ((r + shift - lo) % mod)
	}
	return copy
}

fn chi_squared(count f64, expected_count f64) f64 {
	return math.sqrt(math.abs(count - expected_count)) / expected_count
}