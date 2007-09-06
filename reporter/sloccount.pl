#!/usr/bin/perl
#
# This is a hack to run SLOCCOUNT and send the data back.
# it is not a finished product
#

use warnings;
use strict;

use XML::Simple;
use LWP::UserAgent;
use HTTP::Request::Common;

my $server_url= "http://termite.go-oo.org:3000";


my $branch= $ENV{'BRANCH'};
# discern cws,pws here
my $cws, my $pws;
my @thingy= split /_/, $branch; # coulnd't think of a better name
if (@thingy == 3)
{ # cws: 'cws_src680_dmake411'
    $pws= uc $thingy[1];
    $cws= $thingy[2];
}
elsif (@thingy == 2)
{ # milestone: 'SRC680_m225'
    $pws= $thingy[0];
    $cws = $thingy[1];
}
else
{
    die "$branch doesn't seem to be cws or milestone!\n";
}

# run sloccount
my $sloc_output= `sloccount *`;
die "couldn't run sloccount!\n" unless $? == 0;

# parse output
my $sloc;
foreach my $line (split /\n/, $sloc_output)
{
    if ($line=~/Total Physical Source Lines of Code \(SLOC\)\s+=\s+([\d,]+)/)
    {
	$sloc= $1;
	$sloc=~ s/,//g; # there must be a more elegant way
    }
}

my $hashref= 
{
    'build' => {
	'pws' => $pws,
	'cws' => $cws,
	'builder' => $ENV{'BUILDERNAME'},
	'host' => $ENV{'SLAVENAME'},
	'build_number' => $ENV{'BUILDNUMBER'}
	},
	    'data_item' =>
	{
	    'data_type' => 'sloccount',
	    'data' => {
		'SLOC' => $sloc
		}
	}
};

my $xml= XMLout($hashref, NoAttr => 1, RootName => 'data');
 
my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;
 
my $response = $ua->request(POST "$server_url/data.xml",
			    Content_Type => 'text/xml',
			    Content => $xml);
if ($response->is_success) 
{
    die $response->content;  # oddly an error
}
else 
{
    print $response->status_line; # success!
}
