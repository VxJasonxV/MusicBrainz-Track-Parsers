# Bandcamp Parser #

## Requirements ##

* Perl >= 5.10. I'm not going to explain how to get it nor upgrade to it.

* [URI](https://metacpan.org/pod/URI)

* [LWP::Simple](https://metacpan.org/pod/LWP::Simple)

* [JSON](https://metacpan.org/pod/JSON) >= 2.0 (JSON::XS generally recommended, additionally.)

* [DateTime](https://metacpan.org/pod/DateTime)

* [DateTime::Format::Duration](https://metacpan.org/pod/DateTime::Format::Duration)

This script requires an API Key from Bandcamp. See [http://bandcamp.com/developer#key_request](http://bandcamp.com/developer#key_request). If you have a key, add it to an environment variable called `$BCAPIKEY`. I'm not going to explain how to do this.

## Usage ##

Visit a Bandcamp URL, a specific album or even track as part of an album. Copy the URL and paste it into a terminal as an argument to the Bandcamp script.

ex. `perl bandcamp.pl "http://rainbowdragoneyes.bandcamp.com/track/seize-my-day"`

Artists with only one Album/Track will have that information automatically printed. Otherwise a track will be resolved back to it's release, or printed as-is. An album will be printed as-is. And artist URL with multiple albums will list albums and URLs suitable for immediately copying back into execution.

## Issues? ##

[Let me know!](https://github.com/VxJasonxV/MusicBrainz-Track-Parsers/issues/new?labels[]=bandcamp)

## Roadmap / Wishlist ##

* Refactor
* Refactor
* Refactor
