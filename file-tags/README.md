# Directory File Parsers #

## Requirements ##

* [Audio::Scan](http://search.cpan.org/~agrundma/Audio-Scan-0.87/lib/Audio/Scan.pm)
* Perl. I'm not going to explain how to get it.

## Usage ##

Invoke a file format script suitable for the media in your files, pipe to sort if necessary.

## Roadmap / Wishlist ##

* Suitable framework for detecting file-formats, both dumbly (by extension) and smartly (by file magic/mimetype), turning this into just a single script.
* Seamless `pbcopy` integration into OS X environments.
* Smart artist display, automatically when "Various Artists" is seen, or when differing artists are detected on tracks.
