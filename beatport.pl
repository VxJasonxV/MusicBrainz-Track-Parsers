#!/usr/bin/perl

use warnings;
use strict;

use feature ':5.10';

my $URI = shift @ARGV unless not defined @ARGV;

use Carp qw(croak);

use URI;
use URI::Escape;
use LWP::Simple;
use JSON;

use constant APIROOT => "http://api.beatport.com/catalog/3/beatport/";

my $u = URI->new($URI);

my (undef, $type, $nicename, $id) = split('/', $u->path);

if($type ne 'release')
{ croak "Sorry, only releases are supported right now."; }

my $queryURI = APIROOT . $type . '?id=' . $id;
my $content = get($queryURI);
my $j = decode_json $content;

for(my $i = 0; $i < $j->{'metadata'}->{'tracks'}->{'count'}; $i++)
{
	my $track = $j->{'results'}->{'tracks'}->[$i];
	my $artist = $track->{'artists'};

	my $t = $track->{'title'};
	my @as;

	for(@{$artist})
	{
			if($_->{'type'} ne 'artist')
			{
				next;
			}

			push @as, $_->{'name'};
	}

	print sprintf('%02d', $i+1) . '.	' . $t . ' - ' . join(', ', @as) . '	' . $track->{'length'} . "\n";
}

__END__
http://api.beatport.com/

http://api.beatport.com/beatport-detail-pages.html

http://www.beatport.com/release/different-morals/393408