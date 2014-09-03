# Directory File Parsers #

## Requirements ##

* [Audio::Scan](http://search.cpan.org/~agrundma/Audio-Scan-0.87/lib/Audio/Scan.pm)

* Perl. I'm not going to explain how to get it.

## Usage ##

Invoke a file format script suitable for the media in your files, pipe to sort if necessary. e.g.

```bash
perl readFlacTags.pl "~/Music/Album Zero (2012)"
perl readM4aTags.pl "~/Music/Album Eternus (2013)"
perl readMp3Tags.pl "~/Music/Album Payday (2014)"
```

The executed script will only work on files with expected extensions for the file type.

* `readFlacTags.pl` - `*.flac`

* `readM4aTags.pl` - `*.m4a, *.mp4`

    Because of their DRM, this script cannot work on `m4b` files.

* `readMp3Tags.pl` - `*.mp3`

## Issues? ##

[Let me know!](https://github.com/VxJasonxV/MusicBrainz-Track-Parsers/issues/new?labels[]=file-parsers)

## Roadmap / Wishlist ##

* Suitable framework for detecting file-formats, both dumbly (by extension) and smartly (by file magic/mimetype), turning this into just a single script.

* Seamless pasteboard integration when running under OS X.

* Smart artist display, automatically when "Various Artists" is seen, or when differing artists are detected on tracks.
