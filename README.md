# caesar-salad 🥗

Dynamically break shift ciphers using frequency analysis.

_Currently only the Latin alphabet is supported but support for other alphabets is easy to implement, for more information take a look at: [Contributing](#contributing)_

## Table of contents

- [Quickstart](#quickstart)
- [General Information](#general-information)
- [References](#references)
- [Further Reading](further-reading)
- [Contributing](#contributing)
- [License](#license)

## Quickstart

1. Clone the repository:

```shell
git clone https://github.com/418Coffee/caesar-salad.git
cd caesar-salad/
```

2. Compile the CLI:

_If you're on Windows and have Clang installed you may use [`build.bat`](https://github.com/418Coffee/caesar-salad/blob/main/build.bat)_

```shell
v .
```

3. Use the cli:

```shell
caesar-salad
...
caesar-cipher v0.0.1
-----------------------------------------------
Usage: caesar-cipher [options] [ciphertext]

Description: Dynamically break shift ciphers using frequency analysis

The arguments should be at most 1 in number.

Options:
  -f, --file <string>       input file
  -o, --out <string>        output file
  -l, --language <string>   cipher language
  -h, --help                display this help and exit
  --version                 output version information and exit
Supported languages: en
```

## General Information

A Caesar cipher, or shift cipher, is a monoalphabetic cipher substitution cipher. Each letter in the plaintext is replaced in a toroidal manner by a letter N places down the used alphabet. Any rotation cipher: ROT5, ROT13, etc. is essentially a Caesar cipher. Caesar ciphers are nowadays mostly used in puzzles and provide virtually zero security.

Frequency analysis is the practice of counting letters in text. If you could collect all the books written in a certain language and map out the frequency of each letter in those books you could calculate the relative frequency of each letter in a given text of that language. This counting can be done by each letter (unigrams) but also by each 2 letters (bigrams) and even each n letters (n-grams). Because the Caesar cipher only shifts letters, and therefore n-grams, the frequencies of the n-grams is unchanged. This means you can analyse the given text on the frequency of n-grams and calculate which shift results in the closest representation of the relative frequencies.

## References

- [Caesar cipher](https://en.wikipedia.org/wiki/Caesar_cipher)
- [Frequency analysis](https://en.wikipedia.org/wiki/Frequency_analysis)

## Further Reading

- [Chi-squared test](https://en.wikipedia.org/wiki/Chi-squared_test)
- [Vigenère cipher](https://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher)

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

If you would like to add an language you're free to do so. Find a reputable source of unigram, bigram and trigram frequencies of your language and add a function similair as is done in [`language.v`](https://github.com/418Coffee/caesar-salad/blob/main/language.v).

## License

[MIT](https://choosealicense.com/licenses/mit/)
