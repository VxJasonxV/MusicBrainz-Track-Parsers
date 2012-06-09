#!/usr/bin/perl

use warnings;
use strict;

use feature ':5.10';

my $URI = shift @ARGV unless not defined @ARGV;

use Carp qw(croak); # Yay Coda bug.

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

use Data::Dumper;
my @release;

for(my $i = 0; $i < $j->{'metadata'}->{'tracks'}->{'count'}; $i++)
{
	my %track;
	my $r = $j->{'results'}->{'tracks'}->[$i];
	
	$track{'title'} = $r->{'title'};
	$track{'length'} = $r->{'length'};

	my @as;
	for(@{$r->{'artists'}})
	{
		if($_->{'type'} ne 'artist')
		{
			next;
		}

		push @{$track{'artist'}}, $_->{'name'};
	}
	
	push @release, \%track;
}

print Dumper(\@release);

__END__
http://api.beatport.com/

http://api.beatport.com/beatport-detail-pages.html

http://www.beatport.com/release/different-morals/393408