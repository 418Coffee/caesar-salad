module main

struct UnigramTest {
	test   string
	result []UnigramFrequency
}

fn test_unigram() ? {
	tests := [
		UnigramTest{
			test: 'test'
			result: [
				UnigramFrequency{
					chr: `t`
					freq: 2
				},
				UnigramFrequency{
					chr: `e`
				},
				UnigramFrequency{
					chr: `s`
				},
			]
		},
		UnigramTest{
			test: 'analyse test'
			result: [
				UnigramFrequency{
					chr: `a`
					freq: 2
				},
				UnigramFrequency{
					chr: `e`
					freq: 2
				},
				UnigramFrequency{
					chr: `s`
					freq: 2
				},
				UnigramFrequency{
					chr: `t`
					freq: 2
				},
				UnigramFrequency{
					chr: `l`
				},
				UnigramFrequency{
					chr: `n`
				},
				UnigramFrequency{
					chr: `y`
				},
			]
		},
	]
	for t in tests {
		assert analyse(t.test)?.unigram == t.result
	}
}

fn test_unigram_non_ascii() ? {
	tests := [
		UnigramTest{
			test: 'straße'
			result: [
				UnigramFrequency{
					chr: `a`
				},
				UnigramFrequency{
					chr: `e`
				},
				UnigramFrequency{
					chr: `r`
				},
				UnigramFrequency{
					chr: `s`
				},
				UnigramFrequency{
					chr: `t`
				},
				UnigramFrequency{
					chr: `ß`
				},
			]
		},
		UnigramTest{
			test: 'αγορα'
			result: [
				UnigramFrequency{
					chr: `α`
					freq: 2
				},
				UnigramFrequency{
					chr: `γ`
				},
				UnigramFrequency{
					chr: `ο`
				},
				UnigramFrequency{
					chr: `ρ`
				},
			]
		},
	]
	for t in tests {
		assert analyse(t.test)?.unigram == t.result
	}
}

struct BigramTest {
	test   string
	result []BigramFrequency
}

fn test_bigram() ? {
	tests := [
		BigramTest{
			test: 'test'
			result: [
				BigramFrequency{
					chrs: [`e`, `s`]!
				},
				BigramFrequency{
					chrs: [`s`, `t`]!
				},
				BigramFrequency{
					chrs: [`t`, `e`]!
				},
			]
		},
		BigramTest{
			test: 'he kicked the ball'
			result: [
				BigramFrequency{
					chrs: [`h`, `e`]!
					freq: 2
				},
				BigramFrequency{
					chrs: [`a`, `l`]!
				},
				BigramFrequency{
					chrs: [`b`, `a`]!
				},
				BigramFrequency{
					chrs: [`c`, `k`]!
				},
				BigramFrequency{
					chrs: [`e`, `d`]!
				},
				BigramFrequency{
					chrs: [`i`, `c`]!
				},
				BigramFrequency{
					chrs: [`k`, `e`]!
				},
				BigramFrequency{
					chrs: [`k`, `i`]!
				},
				BigramFrequency{
					chrs: [`l`, `l`]!
				},
				BigramFrequency{
					chrs: [`t`, `h`]!
				},
			]
		},
	]
	for t in tests {
		assert analyse(t.test)?.bigram == t.result
	}
}

fn test_bigram_non_ascii() ? {
	tests := [
		BigramTest{
			test: 'السلام عليكم'
			result: [
				BigramFrequency{
					chrs: [`ا`, `ل`]!
				},
				BigramFrequency{
					chrs: [`ا`, `م`]!
				},
				BigramFrequency{
					chrs: [`س`, `ل`]!
				},
				BigramFrequency{
					chrs: [`ع`, `ل`]!
				},
				BigramFrequency{
					chrs: [`ك`, `م`]!
				},
				BigramFrequency{
					chrs: [`ل`, `ا`]!
				},
				BigramFrequency{
					chrs: [`ل`, `س`]!
				},
				BigramFrequency{
					chrs: [`ل`, `ي`]!
				},
				BigramFrequency{
					chrs: [`ي`, `ك`]!
				},
			]
		},
		BigramTest{
			test: 'पुनर्दर्शनाय'
			result: [
				BigramFrequency{
					chrs: [`र`, `्`]!
					freq: 2
				},
				BigramFrequency{
					chrs: [`द`, `र`]!
				},
				BigramFrequency{
					chrs: [`न`, `र`]!
				},
				BigramFrequency{
					chrs: [`न`, `ा`]!
				},
				BigramFrequency{
					chrs: [`प`, `ु`]!
				},
				BigramFrequency{
					chrs: [`श`, `न`]!
				},
				BigramFrequency{
					chrs: [`ा`, `य`]!
				},
				BigramFrequency{
					chrs: [`ु`, `न`]!
				},
				BigramFrequency{
					chrs: [`्`, `द`]!
				},
				BigramFrequency{
					chrs: [`्`, `श`]!
				},
			]
		},
	]
	for t in tests {
		assert analyse(t.test)?.bigram == t.result
	}
}

struct TrigramTest {
	test   string
	result []TrigramFrequency
}

fn test_trigram() ? {
	tests := [
		TrigramTest{
			test: 'test'
			result: [
				TrigramFrequency{
					chrs: [`e`, `s`, `t`]!
				},
				TrigramFrequency{
					chrs: [`t`, `e`, `s`]!
				},
			]
		},
		TrigramTest{
			test: 'there are trigrams in the sentence'
			result: [
				TrigramFrequency{
					chrs: [`t`, `h`, `e`]!
					freq: 2
				},
				TrigramFrequency{
					chrs: [`a`, `m`, `s`]!
				},
				TrigramFrequency{
					chrs: [`a`, `r`, `e`]!
				},
				TrigramFrequency{
					chrs: [`e`, `n`, `c`]!
				},
				TrigramFrequency{
					chrs: [`e`, `n`, `t`]!
				},
				TrigramFrequency{
					chrs: [`e`, `r`, `e`]!
				},
				TrigramFrequency{
					chrs: [`g`, `r`, `a`]!
				},
				TrigramFrequency{
					chrs: [`h`, `e`, `r`]!
				},
				TrigramFrequency{
					chrs: [`i`, `g`, `r`]!
				},
				TrigramFrequency{
					chrs: [`n`, `c`, `e`]!
				},
				TrigramFrequency{
					chrs: [`n`, `t`, `e`]!
				},
				TrigramFrequency{
					chrs: [`r`, `a`, `m`]!
				},
				TrigramFrequency{
					chrs: [`r`, `i`, `g`]!
				},
				TrigramFrequency{
					chrs: [`s`, `e`, `n`]!
				},
				TrigramFrequency{
					chrs: [`t`, `e`, `n`]!
				},
				TrigramFrequency{
					chrs: [`t`, `r`, `i`]!
				},
			]
		},
	]
	for t in tests {
		assert analyse(t.test)?.trigram == t.result
	}
}

fn test_trigram_non_ascii() ? {
	tests := [
		TrigramTest{
			test: '很高兴认识你'
			result: [
				TrigramFrequency{
					chrs: [`兴`, `认`, `识`]!
				},
				TrigramFrequency{
					chrs: [`很`, `高`, `兴`]!
				},
				TrigramFrequency{
					chrs: [`认`, `识`, `你`]!
				},
				TrigramFrequency{
					chrs: [`高`, `兴`, `认`]!
				},
			]
		},
		TrigramTest{
			test: '𓇾𓈇𓏤𓊪𓏲𓄤𓆑𓂋𓇋𓄿𓄿𓆰𓈉𓂋𓈖 𓆑'
			result: [
				TrigramFrequency{
					chrs: [`𓂋`, `𓇋`, `𓄿`]!
				},
				TrigramFrequency{
					chrs: [`𓄤`, `𓆑`, `𓂋`]!
				},
				TrigramFrequency{
					chrs: [`𓄿`, `𓄿`, `𓆰`]!
				},
				TrigramFrequency{
					chrs: [`𓄿`, `𓆰`, `𓈉`]!
				},
				TrigramFrequency{
					chrs: [`𓆑`, `𓂋`, `𓇋`]!
				},
				TrigramFrequency{
					chrs: [`𓆰`, `𓈉`, `𓂋`]!
				},
				TrigramFrequency{
					chrs: [`𓇋`, `𓄿`, `𓄿`]!
				},
				TrigramFrequency{
					chrs: [`𓇾`, `𓈇`, `𓏤`]!
				},
				TrigramFrequency{
					chrs: [`𓈇`, `𓏤`, `𓊪`]!
				},
				TrigramFrequency{
					chrs: [`𓈉`, `𓂋`, `𓈖`]!
				},
				TrigramFrequency{
					chrs: [`𓊪`, `𓏲`, `𓄤`]!
				},
				TrigramFrequency{
					chrs: [`𓏤`, `𓊪`, `𓏲`]!
				},
				TrigramFrequency{
					chrs: [`𓏲`, `𓄤`, `𓆑`]!
				},
			]
		},
	]
	for t in tests {
		assert analyse(t.test)?.trigram == t.result
	}
}

struct AlphabetASCIITest {
	test   string
	result bool
}

fn test_is_alphabet_ascii() {
	tests := [
		AlphabetASCIITest{
			test: 'A'
			result: true
		},
		AlphabetASCIITest{
			test: 'z'
			result: true
		},
		AlphabetASCIITest{
			test: ' '
			result: true
		},
		AlphabetASCIITest{
			test: '['
			result: false
		},
	]
	for t in tests {
		assert is_alphabet_ascii(t.test) == t.result
	}
}
