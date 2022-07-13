module main

import encoding.utf8

struct Frequencies {
	unigram []UnigramFrequency
	bigram  []BigramFrequency
	trigram []TrigramFrequency
}

// UnigramFrequency is the frequency of a single unicode character in a given text.
struct UnigramFrequency {
	chr rune
mut:
	freq u64 = 1
}

// BigramFrequency is the frequency of a sequence of two adjacent unicode characters in a given text.
struct BigramFrequency {
	chrs [2]rune
mut:
	freq u64 = 1
}

// BigramFrequency is the frequency of a sequence of three adjacent unicode characters in a given text.
struct TrigramFrequency {
	chrs [3]rune
mut:
	freq u64 = 1
}

// analyse analyses text in unigram, bigram and trigram parts and returns a struct with the frequency of each n-gram as unicode characters respectively,
// The n-grams are sorted by frequency and character respectively.
// The space character ` ` is omitted from the analysis.
fn analyse(text string) ?Frequencies {
	mut unigram_frequencies := map[rune]UnigramFrequency{}
	mut bigram_frequencies := map[string]BigramFrequency{}
	mut trigram_frequencies := map[string]TrigramFrequency{}
	text_runes := text.runes()
	for i := 0; i < text_runes.len; i++ {
		chr := text_runes[i]
		if should_skip(chr) {
			continue
		}
		if chr in unigram_frequencies {
			unigram_frequencies[chr].freq++
		} else {
			unigram_frequencies[chr] = UnigramFrequency{
				chr: chr
			}
		}
		if text_runes.len <= i + 1 || should_skip(text_runes[i + 1]) {
			continue
		}
		bigram := chr.str() + text_runes[i + 1].str()
		if bigram in bigram_frequencies {
			bigram_frequencies[bigram].freq++
		} else {
			bigram_frequencies[bigram] = BigramFrequency{
				chrs: [chr, text_runes[i + 1]]!
			}
		}
		if text_runes.len <= i + 2 || should_skip(text_runes[i + 2]) {
			continue
		}
		trigram := chr.str() + text_runes[i + 1].str() + text_runes[i + 2].str()
		if trigram in trigram_frequencies {
			trigram_frequencies[trigram].freq++
		} else {
			trigram_frequencies[trigram] = TrigramFrequency{
				chrs: [chr, text_runes[i + 1], text_runes[i + 2]]!
			}
		}
	}
	mut unigram := unigram_frequencies.values()
	mut bigram := bigram_frequencies.values()
	mut trigram := trigram_frequencies.values()
	sort_unigram_freq_chr := fn (a &UnigramFrequency, b &UnigramFrequency) int {
		// return -1 when a comes before b
		// return 0, when both are in same order
		// return 1 when b comes before a
		if a.freq == b.freq {
			if a.chr > b.chr {
				return 1
			} else if a.chr < b.chr {
				return -1
			}
			return 0
		} else if a.freq > b.freq {
			return -1
		} else if a.freq < b.freq {
			return 1
		}
		return 0
	}
	sort_bigram_freq_chrs := fn (a &BigramFrequency, b &BigramFrequency) int {
		if a.freq == b.freq {
			return compare(a.chrs[..], b.chrs[..])
			// if a.chrs[0] == b.chrs[0] {
			// 	if a.chrs[1] > b.chrs[1] {
			// 		return 1
			// 	} else if a.chrs[1] < b.chrs[1] {
			// 		return -1
			// 	}
			// 	return 0
			// } else if a.chrs[0] > b.chrs[0] {
			// 	return 1
			// } else if a.chrs[0] < b.chrs[0] {
			// 	return -1
			// }
			// return 0
		}
		if a.freq > b.freq {
			return -1
		} else if a.freq < b.freq {
			return 1
		}
		return 0
	}
	sort_trigram_freq_chrs := fn (a &TrigramFrequency, b &TrigramFrequency) int {
		if a.freq == b.freq {
			return compare(a.chrs[..], b.chrs[..])
			// if a.chrs[0] == b.chrs[0] {
			// 	if a.chrs[1] == b.chrs[1] {
			// 		if a.chrs[2] > b.chrs[2] {
			// 			return 1
			// 		} else if a.chrs[2] < b.chrs[2] {
			// 			return -1
			// 		}
			// 		return 0
			// 	} else if a.chrs[1] > b.chrs[1] {
			// 		return 1
			// 	} else if a.chrs[1] < b.chrs[1] {
			// 		return -1
			// 	}
			// 	return 0
			// } else if a.chrs[0] > b.chrs[0] {
			// 	return 1
			// } else if a.chrs[0] < b.chrs[0] {
			// 	return -1
			// }
			// return 0
		} else if a.freq > b.freq {
			return -1
		} else if a.freq < b.freq {
			return 1
		}
		return 0
	}
	unigram.sort_with_compare(sort_unigram_freq_chr)
	bigram.sort_with_compare(sort_bigram_freq_chrs)
	trigram.sort_with_compare(sort_trigram_freq_chrs)
	return Frequencies{
		unigram: unigram
		bigram: bigram
		trigram: trigram
	}
}

fn is_alphabet_ascii(s string) bool {
	return !s.bytes().any((it < 65 || it > 90) && (it < 97 || it > 122) && it != 32)
}

[inline]
fn should_skip(r rune) bool {
	return !utf8.is_letter(r) // utf8.is_control(r) || r == ` `
}

// maybe the compiler is smart enough to, in our case, inline the recursion.
[inline]
fn compare(a []rune, b []rune) int {
	if a.len != b.len {
		panic('a.len=$a.len != b.len=$b.len')
	}
	// return -1 when a comes before b
	// return 0, when both are in same order
	// return 1 when b comes before a
	for i in 0 .. a.len {
		if a[i] == b[i] {
			return compare(a[i + 1..], b[i + 1..])
		} else if a[i] > b[i] {
			return 1
		} else if a[i] < b[i] {
			return -1
		}
	}
	return 0
}
