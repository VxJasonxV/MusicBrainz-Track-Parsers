#!/usr/bin/perl

use warnings;
use strict;

use feature ':5.10';

use Carp qw(croak);

my $key = $ENV{'BCAPIKEY'};

if($key eq '')
{
	croak "An environment variable named \$BCAPIKEY is required to use this script. Get one from the instructions listed at http://bandcamp.com/developer#key_request.";
}

my $URI = shift @ARGV unless not defined @ARGV;
my $u = URI->new($URI);

sub format_duration
{
	my $time = shift;
	
	use DateTime::Format::Duration;
	
	my $d = DateTime::Format::Duration->new(
		pattern => '%M:%S',
		normalize => 1
	);
	
	return "(" . $d->format_duration(
		DateTime::Duration->new(
			seconds => $time
		)
	) . ")";
}

sub determine_bandcamp_feature
{
}

if($u->host eq 'api.bandcamp.com')
{
	# Pass the first path option to the relevent parser.
	croak "Not implemented yet.";
}

# We can gauge our expectations by getting information about the URI. Is it an Artist? Album? Track?
my @pathInfo = split(/\//, $u->path);

use URI;
use URI::Escape qw(uri_escape);

my $queryURI = "http://api.bandcamp.com/api/url/1/info?key=${key}&url=" . uri_escape($u->clone);

use LWP::Simple;

my $content = get($queryURI);

use JSON;

my $j = decode_json $content;
undef $content;

if(not @pathInfo)
{
	# If only one album is present, display it properly formatted.
	# Otherwise, list the artist's albums and give up.
	
	$content = get("http://api.bandcamp.com/api/band/3/discography?key=${key}&band_id=" . $j->{band_id});
	my $a = decode_json $content;
	undef $content;
	
	# You always need an artist name, it's only set in the album info if it's a VA release.
	# No matter the path we take, we need this.
	my $bandName = $a->{discography}->[0]->{artist};
	
	if(@{$a->{discography}} == 1)
	{
		my $id;
		# Is there an album_id or a track_id?
		if($id = $a->{discography}->[0]->{album_id})
		{
			$content = get("http://api.bandcamp.com/api/album/2/info?key=${key}&album_id=" . $id);
			my $b = decode_json $content;
			undef $content;
		
			{
				local $\ = "\n";
				
				print "$b->{title}, by $bandName";
				
				for my $t (@{$b->{tracks}})
				{
					my $trackNr = "$t->{number}.";
					my $title = $t->{title};
					my $artist = $t->{artist} || $bandName;
					my $titleMinusArtist = "$title - $artist";
					my $duration = format_duration($t->{duration});
					my $line = join(' ', $trackNr, $titleMinusArtist, $duration);
					print $line;
				}
			}
		}
		elsif($id = $a->{discography}->[0]->{track_id})
		{
			$content = get("http://api.bandcamp.com/api/track/1/info?key=${key}&track_id=" . $id);
			my $a = decode_json $content;
			undef $content;

			{
				local $\ = "\n";

				print "$a->{title}, by $bandName";

				my $trackNr = "1.";
				my $title = $a->{title};
				my $artist = $a->{artist} || $bandName;
				my $titleMinusArtist = "$title - $artist";
				my $duration = format_duration($a->{duration});
				my $line = join(' ', $trackNr, $titleMinusArtist, $duration);
				print $line;
			}
		}
	}
	elsif(@{$a->{discography}} > 1)
	{
		{
			local $\ = "\n";
			
			print "This artist has multiple albums:";
			for my $t (@{$a->{discography}})
			{
				print "$t->{title} - $t->{url}";
			}
		}
	}
	else
	{
		print "This artist has no albums. We're done here.\n";
		exit;
	}
	
	exit;
}

if($pathInfo[1] eq "album")
{
	# Albums provide everything (well, almost everything ¬_¬) so just display it as a release.
	$content = get("http://api.bandcamp.com/api/album/2/info?key=${key}&album_id=" . $j->{album_id});
	my $a = decode_json $content;
	undef $content;
	
	# You always need to query for an artist name, it's only set in the album info if it's a VA release.
	$content = get("http://api.bandcamp.com/api/band/3/info?key=${key}&band_id=" . $a->{band_id});
	my $k = decode_json $content;
	undef $content;
	my $bandName = $k->{name};
	
	{
		local $\ = "\n";
		
		print "$a->{title}, by $bandName";
		
		for my $t (@{$a->{tracks}})
		{
			my $trackNr = "$t->{number}.";
			my $title = $t->{title};
			my $artist = $t->{artist} || $bandName;
			my $titleMinusArtist = "$title - $artist";
			my $duration = format_duration($t->{duration});
			my $line = join(' ', $trackNr, $titleMinusArtist, $duration);
			print $line;
		}
	}
	
	exit;
}

if($pathInfo[1] eq "track")
{
	$content = get("http://api.bandcamp.com/api/track/1/info?key=${key}&track_id=" . $j->{track_id});
	my $a = decode_json $content;
	undef $content;
	
	# You always need to query for an artist name, it's only set in the album info if it's a VA release.
	# No matter the path we take, we need this.
	$content = get("http://api.bandcamp.com/api/band/3/info?key=${key}&band_id=" . $j->{band_id});
	my $k = decode_json $content;
	undef $content;
	my $bandName = $k->{name};
	
	if($a->{album_id})
	{
		# Albums provide everything (well, almost everything ¬_¬) so just display it as a release.
		$content = get("http://api.bandcamp.com/api/album/2/info?key=${key}&album_id=" . $a->{album_id});
		my $a = decode_json $content;
		undef $content;
		
		{
			local $\ = "\n";
			
			print "$a->{title}, by $bandName";
			
			for my $t (@{$a->{tracks}})
			{
				my $trackNr = "$t->{number}.";
				my $title = $t->{title};
				my $artist = $t->{artist} || $bandName;
				my $titleMinusArtist = "$title - $artist";
				my $duration = format_duration($t->{duration});
				my $line = join(' ', $trackNr, $titleMinusArtist, $duration);
				print $line;
			}
		}
	}
	else # If a track is not released on an album, we already have all the info from the first query in this section.
	{
		{
			local $\ = "\n";
			
			print "$j->{title}, by $bandName";
			
			my $trackNr = "1.";
			my $title = $j->{title};
			my $artist = $j->{artist} || $bandName;
			my $titleMinusArtist = "$title - $artist";
			my $duration = format_duration($j->{duration});
			my $line = join(' ', $trackNr, $titleMinusArtist, $duration);
			print $line;
		}
	}

	exit;
}

__END__

An artist with no albums, just tracks ("singles"):

http://api.bandcamp.com/api/url/1/info?key=<apikey>&url=esunrobo.bandcamp.com

An artist with only albums:

http://api.bandcamp.com/api/url/1/info?key=<apikey>&url=rainbowdragoneyes.bandcamp.com

An artist with tracks and albums:



An empty artist:

http://api.bandcamp.com/api/url/1/info?key=<apikey>&url=jsound.bandcamp.com

An artist with only one release:

http://api.bandcamp.com/api/url/1/info?key=<apikey>&url=doomcloud.bandcamp.com

An artist with only one track:

