# Directory File Parsers #

## Requirements ##

* [Audio::Scan](http://search.cpan.org/~agrundma/Audio-Scan-0.87/lib/Audio/Scan.pm)
* Perl. I'm not going to explain how to get it.

## Usage ##

Invoke a file format script suitable for the media in your files, pipe to sort if necessary. e.g.

```bash
perl readFlacTags.pl "~/Music/Album Zero (2012)/*.flac"
perl readM4aTags.pl "~/Music/Album Eternus (2013)/*.{m4a,mp4}"
perl readMp3Tags.pl "~/Music/Album Payday (2014)/*.mp3"
```

## Issues? ##

[Let me know!](https://github.com/VxJasonxV/MusicBrainz-Track-Parsers/issues/new?labels[]=file-parsers)

## Roadmap / Wishlist ##

* Suitable framework for detecting file-formats, both dumbly (by extension) and smartly (by file magic/mimetype), turning this into just a single script.
* Seamless `pbcopy` integration into OS X environments.
* Smart artist display, automatically when "Various Artists" is seen, or when differing artists are detected on tracks.
