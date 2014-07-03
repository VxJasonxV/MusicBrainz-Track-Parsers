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

--------

# Bandcamp Parser #

## Requirements ##

* Perl >= 5.10. I'm not going to explain how to get it nor upgrade to it.
* [URI](https://metacpan.org/pod/URI)
* [LWP::Simple](https://metacpan.org/pod/LWP::Simple)
* [JSON](https://metacpan.org/pod/JSON) >= 2.0 (JSON::XS generally recommended, additionally.)
* [DateTime](https://metacpan.org/pod/DateTime)
* [DateTime::Format::Duration](https://metacpan.org/pod/DateTime::Format::Duration)

* Requires an API Key from Bandcamp. See [http://bandcamp.com/developer#key_request](http://bandcamp.com/developer#key_request)
* Add the API Key into your environment as the value of the $BCAPIKEY variable. I'm not going to explain how to do this.

## Usage ##

Visit a Bandcamp URL, a specific album or even track as part of an album. Copy the URL and paste it into a terminal as an argument to the Bandcamp script.

Ex. `perl bandcamp.pl "http://rainbowdragoneyes.bandcamp.com/track/seize-my-day"`

Artists with only one Album/Track will have that information automatically printed. Otherwise a track will be resolved back to it's release, or printed as-is. An album will be printed as-is. And artist URL with multiple albums will list albums and URLs suitable for immediately copying back into execution.

## Roadmap / Wishlist ##

* Refactor
* Refactor
* Refactor

--------

# Beatport Parser #

## Requirements ##

* Perl >= 5.10
* [LWP::Simple](https://metacpan.org/pod/LWP::Simple)
* [JSON](https://metacpan.org/pod/JSON) >= 2.0 (JSON::XS generally recommended, additionally.)
* [Carp](https://metacpan.org/pod/Carp)
* [HTML::Query](https://metacpan.org/pod/HTML::Query)
* [File::Temp](https://metacpan.org/pod/File::Temp)

## Usage ##

Visit a beatport.com release page, it MUST begin with beatport.com/release. Copy the URL and paste it into a terminal as an argument to the Beatport script.

Ex. `perl beatport.pl "http://www.beatport.com/release/different-morals/393408"`

## Caveats ##

Artist information may be quite a bit wacky, mostly because Beatport's artist classification is insanity. Please take care to check that all artist credits are correct. If you know more than me about how Beatport represents their artists, [let me know!](https://github.com/VxJasonxV/MusicBrainz-Track-Parsers/issues)

## Roadmap / Wishlist ##

* General cleanup and some error handling maybe?
