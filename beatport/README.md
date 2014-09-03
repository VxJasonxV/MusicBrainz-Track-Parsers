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

ex. `perl beatport.pl "http://www.beatport.com/release/different-morals/393408"`

## Caveats ##

Artist information may be quite a bit wacky, mostly because Beatport's artist classification is insanity. Please take care to check that all artist credits are correct. If you know more than me about how Beatport represents their artists, [let me know!](https://github.com/VxJasonxV/MusicBrainz-Track-Parsers/issues/new?labels[]=beatport)

## Roadmap / Wishlist ##

* General cleanup and some error handling maybe?
