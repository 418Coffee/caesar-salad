module main

import os
import flag

fn main() {
	supported_languages := languages.map(it.name)
	mut fp := flag.new_flag_parser(os.args)
	fp.application('caesar-cipher')
	fp.description('Dynamically break shift ciphers using frequency analysis')
	fp.footer('Supported languages: ${supported_languages.join(' ')}')
	fp.version('v0.0.1')
	fp.limit_free_args(0, 1)?
	fp.skip_executable()
	fp.arguments_description('[ciphertext]')
	file := fp.string('file', `f`, '', 'input file')
	out := fp.string('out', `o`, '', 'output file')
	lang := fp.string('language', `l`, 'en', 'cipher language')
	additional_args := fp.finalize() or {
		eprintln(err)
		println(fp.usage())
		return
	}
	// mutual exclusion
	if (file.len == 0 && additional_args.len == 0) || (file.len > 0 && additional_args.len > 0) {
		eprintln('the input file and ciphertext argument are mutually exclusive')
		println(fp.usage())
		return
	}
	// unsupported language
	if lang !in supported_languages {
		eprintln('unsupported language: $lang')
		println(fp.usage())
		return
	}
	mut ciphertext := ''
	if file.len > 0 {
		ciphertext = os.read_file(file) or {
			eprintln('error reading input: $err')
			return
		}
	} else {
		ciphertext = additional_args[0]
	}
	l := languages.filter(it.name == lang)[0]
	best_guess, key := l.guess(ciphertext) or {
		eprintln(err)
		return
	}
	println('key: $key')
	if out.len > 0 {
		os.write_file(out, best_guess) or {
			eprintln('error writing to output file: $err')
			return
		}
		println('wrote output to $out')
		return
	}
	println('output:')
	println(best_guess)
}
