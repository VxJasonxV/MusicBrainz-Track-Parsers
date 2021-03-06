#!/usr/bin/perl

use warnings;
use strict;

use feature ':5.10';

use Carp qw(croak);
sub strip_non_main_artists
{
	croak "Oops no artist!" unless @_;

	my @artists = @_;

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

	return @a;
}

if (not @ARGV)
{
	croak "Please provide a URL, ex.: perl $0 'http://www.beatport.com/release/stay-the-night/1187110'";
}

my $URI = shift @ARGV;

use LWP::Simple;
my $content = get($URI);

use HTML::Query 'Query';

my $c = Query( text => $content, 'div.release-detail' );

my %release;

# Query first for the catalog number
my $catno = $c->query('table.meta-data td.meta-data-value');
$release{'catno'} = $catno->last->as_text;

# Get the release artist which is only guarenteed to be in the page header
$release{'artist'} = ($c->query('div.lastUnit > div.txt-uppercase')->as_trimmed_text)[0];

# And then for the tracks on the release
my @tracks = $c->query('span[data-json]')->attr('data-json');

use JSON qw(decode_json);

my $r = decode_json $tracks[0];
$release{'title'} = $r->{'release'}->{'name'};
($release{'relyear'}, $release{'relmonth'}, $release{'relday'}) = (split(/-/, $r->{'releaseDate'}));
$release{'label'} = $r->{'label'}->{'name'};
$release{'meta'}{'type'} = $r->{'type'};
$release{'meta'}{'slug'} = $r->{'slug'};
$release{'meta'}{'id'} = $r->{'id'};
$release{'metadata'}{'track'}{'count'} = scalar @tracks;

for(my $i = 0; $i < scalar @tracks; $i++)
{
	my $metadata = decode_json $tracks[$i];
	my %track;

	$track{'title'} = $metadata->{'title'};
	$track{'length'} = $metadata->{'length'};

	@{$track{'artists'}} = strip_non_main_artists(@{$metadata->{'artists'}});
	push @{$release{'tracks'}}, \%track;
}

$release{'editnote'} = "Imported from $URI";

use File::Temp qw(tempfile);

my $tmp = File::Temp->new(
	TEMPLATE => "beatport-${release{'meta'}{'id'}}-${release{'meta'}{'slug'}}-XXXXXX",
	DIR => '/tmp/',
	SUFFIX => '.html'
);

binmode( $tmp, ":utf8" );
my ($i, $j);

# http://musicbrainz.org/doc/Release_Editor_Seeding
print $tmp <<HTML;
<html>
<head>
<title>Submit ${release{'title'}} to MusicBrainz</title>
</head>
<body>
<form action="http://musicbrainz.org/release/add" method="post">
<input type="hidden" name="name" value="${release{'title'}}" />
<input type="hidden" name="artist_credit.names.0.name" value="${release{'artist'}}" />
<input type="hidden" name="country" value="XW" />
<input type="hidden" name="packaging" value="none" />
<input type="hidden" name="labels.0.name" value="${release{'label'}}" />
<input type="hidden" name="labels.0.catalog_number" value="${release{'catno'}}" />
<input type="hidden" name="date.year" value="${release{'relyear'}}" />
<input type="hidden" name="date.month" value="${release{'relmonth'}}" />
<input type="hidden" name="date.day" value="${release{'relday'}}" />
<input type="hidden" name="mediums.0.format" value="Digital Media" />
<input type="hidden" name="urls.0.url" value="$URI" />
HTML

my ($t, $a);
$i = 0;
for $t (@{$release{'tracks'}})
{
	print $tmp "<input type='hidden' name='mediums.0.track.$i.name' value=\"$t->{'title'}\" />\n";
	$j = 0;
	for $a (@{$t->{'artists'}})
	{
		print $tmp "<input type='hidden' name='mediums.0.track.$i.artist_credit.names.$j.name' value='$a' />\n";
		$j++;
	}
	print $tmp "<input type='hidden' name='mediums.0.track.$i.length' value=\"$t->{'length'}\" />\n";
	$i++;
}

print $tmp <<HTML;
<input type="hidden" name="edit_note" value="${release{'editnote'}}" />
<input type="hidden" name="as_auto_editor" value="1" />
<input type="submit" value="Just click me" />
</form>
<script>document.forms[0].submit()</script>
</body>
</html>
HTML

my @cmd = ("open", "$tmp");
system(@cmd);
sleep 5;

__END__
http://www.beatport.com/release/rockin-n-rollin-the-remixes/1143465
