#!/usr/bin/perl

use warnings;
use strict;

use feature ':5.10';

my $URI = shift @ARGV unless not defined @ARGV;

use Carp qw(croak); # Yay Coda bug.

sub strip_non_main_artists
{
	croak "Oops no artist!" unless @_;
	
	my @artists = shift @_;
	
	if( scalar(@artists) == 1)
	{ return $artists[0]->{'name'}; }

	my @a;
	for(@artists)
	{
		if($_->{'type'} ne 'artist')
		{
			next;
		}

		push @a, $_->{'name'};
	}

	return \@a;
}

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

my %release;

{
	my $r = $j->{'results'}->{'release'};
	$release{'title'} = $r->{'name'};
	$release{'artist'} = strip_non_main_artists(@{$r->{'artists'}});
	($release{'relyear'}, $release{'relmonth'}, $release{'relday'}) = (split(/-/, $r->{'releaseDate'}));
	$release{'label'} = $r->{'label'}->{'name'};
	$release{'catno'} = $r->{'catalogNumber'};
	$release{'meta'}{'type'} = $r->{'type'};
	$release{'meta'}{'slug'} = $r->{'slug'};
	$release{'meta'}{'id'} = $r->{'id'};
}

for(my $i = 0; $i < $j->{'metadata'}->{'tracks'}->{'count'}; $i++)
{
	my %track;
	my $s = $j->{'results'}->{'tracks'}->[$i];
	
	$track{'title'} = $s->{'title'};
	$track{'length'} = $s->{'length'};

	$track{'artist'} = strip_non_main_artists(@{$s->{'artists'}});
	
	push @{$release{'tracks'}}, \%track;
}

$release{'editnote'} = "Imported from http://www.beatport.com/${release{'meta'}{'type'}}/${release{'meta'}{'slug'}}/${release{'meta'}{'id'}}";

use File::Temp qw(tempfile); # Yay Coda bug x2.

my $tmp = File::Temp->new(
	TEMPLATE => "beatport-${release{'meta'}{'id'}}-${release{'meta'}{'slug'}}-XXXXXX",
	DIR => '/tmp/',
	SUFFIX => '.html'
);

binmode( $tmp, ":utf8" );

print $tmp <<HTML;
<html>
<head>
<title>Submit release to MusicBrainz</title>
</head>
<body>
<form method="POST" action="http://musicbrainz.org/release/add">
<input type="hidden" name="name" value="${release{'title'}}" />
<input type="hidden" name="artist_credit.names.0.name" value="${release{'artist'}}" />
<input type="hidden" name="country" value="XW" />
<input type="hidden" name="labels.0.name" value="${release{'label'}}" />
<input type="hidden" name="labels.0.catalog_number" value="${release{'catno'}}" />
<input type="hidden" name="date.year" value="${release{'relyear'}}" />
<input type="hidden" name="date.month" value="${release{'relmonth'}}" />
<input type="hidden" name="date.day" value="${release{'relday'}}" />
HTML

my $i = 0;
for (@{$release{'tracks'}})
{
	print $tmp "<input type='hidden' name='mediums.0.track.$i.name' value=\"$_->{'title'}\" />\n";
	print $tmp "<input type='hidden' name='mediums.0.track.$i.artist_credit.names.0.name' value=\"$_->{'artist'}\" />\n";
	print $tmp "<input type='hidden' name='mediums.0.track.$i.length' value=\"$_->{'length'}\" />\n";
	$i++;
}

print $tmp <<HTML;
<input type="hidden" name="edit_note" value="Imported from $u" />
<input type="hidden" name="as_auto_editor" value="1" />
<input type="submit" name="submit" value="Just click me" />
</form>
</body>
</html>
HTML

my @cmd = ("open", "$tmp");
system(@cmd);
<STDIN>;

__END__
http://api.beatport.com/

http://api.beatport.com/beatport-detail-pages.html

http://www.beatport.com/release/different-morals/393408