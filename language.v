module main

import encoding.utf8
import math

// alphabets
const (
	latin = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
)

// languages
const languages = [english()]

struct Language {
	// ISO 639-1 preferably.
	name         string
	alphabet     string
	top_unigrams map[rune]f64
	top_bigrams  map[string]f64
	top_trigrams map[string]f64
}

fn (l Language) guess(ciphertext string) ?(string, int) {
	ciphertext_runes := utf8.to_upper(ciphertext).runes()
	mut eud := map[rune]f64{}
	mut ebd := map[string]f64{}
	mut etd := map[string]f64{}
	for chr, prob in l.top_unigrams {
		eud[chr] = prob * ciphertext_runes.len
	}
	mut bigram_covered_prob := f64(0)
	for chrs, prob in l.top_bigrams {
		ebd[chrs] = prob * ciphertext_runes.len
		bigram_covered_prob += prob
	}
	bigram_normal_freq := ((1 - bigram_covered_prob) / (math.pow(l.alphabet.len, 2) - ebd.len)) * ciphertext_runes.len
	mut trigram_covered_prob := f64(0)
	for chrs, prob in l.top_trigrams {
		etd[chrs] = prob * ciphertext_runes.len
		trigram_covered_prob += prob
	}
	trigram_normal_freq := ((1 - trigram_covered_prob) / (math.pow(l.alphabet.len, 3) - etd.len)) * ciphertext_runes.len

	mut best_guess := []rune{}
	mut lowest_sum := math.max_f64
	mut key := 0
	for k in 0 .. l.alphabet.len {
		plaintext := shift(ciphertext_runes, k, l.alphabet[0], l.alphabet.len)
		frequencies := analyse(plaintext.string())?
		mut sum := f64(0)
		for uf in frequencies.unigram {
			sum += chi_squared(f64(uf.freq), eud[uf.chr])
		}
		for bf in frequencies.bigram {
			if expected_freq := ebd[bf.chrs[..].string()] {
				sum += chi_squared(f64(bf.freq), expected_freq)
			} else {
				sum += chi_squared(f64(bf.freq), bigram_normal_freq)
			}
		}
		for tf in frequencies.trigram {
			if expected_freq := etd[tf.chrs[..].string()] {
				sum += chi_squared(f64(tf.freq), expected_freq)
			} else {
				sum += chi_squared(f64(tf.freq), trigram_normal_freq)
			}
		}
		if sum < lowest_sum {
			// Use this println to debug.
			// println('key=$key sum=$sum')
			lowest_sum = sum
			best_guess = unsafe { plaintext }
			key = k
		}
	}
	return best_guess.string().to_lower(), key
}

fn english() Language {
	return Language{
		name: 'en'
		alphabet: latin
		top_unigrams: {
			`E`: 0.12575645
			`T`: 0.09085226
			`A`: 0.08000395
			`O`: 0.07591270
			`I`: 0.06920007
			`N`: 0.06903785
			`S`: 0.06340880
			`H`: 0.06236609
			`R`: 0.05959034
			`D`: 0.04317924
			`L`: 0.04057231
			`U`: 0.02841783
			`C`: 0.02575785
			`M`: 0.02560994
			`F`: 0.02350463
			`W`: 0.02224893
			`G`: 0.01982677
			`Y`: 0.01900888
			`P`: 0.01795742
			`B`: 0.01535701
			`V`: 0.00981717
			`K`: 0.00739906
			`X`: 0.00179556
			`J`: 0.00145188
			`Q`: 0.00117571
			`Z`: 0.00079130
		}
		top_bigrams: {
			'TH': 0.03882543
			'HE': 0.03681391
			'IN': 0.02283899
			'ER': 0.02178042
			'AN': 0.02140460
			'RE': 0.01749394
			'ND': 0.01571977
			'ON': 0.01418244
			'EN': 0.01383239
			'AT': 0.01335523
			'OU': 0.01285484
			'ED': 0.01275779
			'HA': 0.01274742
			'TO': 0.01169655
			'OR': 0.01151094
			'IT': 0.01134891
			'IS': 0.01109877
			'HI': 0.01092302
			'ES': 0.01092301
			'NG': 0.01053385
		}
		top_trigrams: {
			'THE': 0.03508232
			'AND': 0.01593878
			'ING': 0.01147042
			'HER': 0.00822444
			'HAT': 0.00650715
			'HIS': 0.00596748
			'THA': 0.00593593
			'ERE': 0.00560594
			'FOR': 0.00555372
			'ENT': 0.00530771
			'ION': 0.00506454
			'TER': 0.00461099
			'WAS': 0.00460487
			'YOU': 0.00437213
			'ITH': 0.00431250
			'VER': 0.00430732
			'ALL': 0.00422758
			'WIT': 0.00397290
			'THI': 0.00394796
			'TIO': 0.00378058
		}
	}
}
