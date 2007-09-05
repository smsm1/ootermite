# the purpose of this script is to figureout how to send data


use warnings;
use strict;

use XML::Simple;
use LWP::UserAgent;
use HTTP::Request::Common;

my $hashref= 
{
    'build' => {
	'pws' => 'SRC680_m181',
	'cws' => 'configdbbe',
	'builder' => 'builder1',
	'host' => 'host1',
	'build_number' => 12
	},
	    'data_item' =>
	{
	    'data_type' => 'type2',
	    'data' => {
		'value' => '1'
		}
	}
};

my $xml= XMLout($hashref, NoAttr => 1, RootName => 'data');
 
my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;
 
#w00t this works! 
my $response = $ua->request(POST 'http://localhost:3000/data.xml',
			    Content_Type => 'text/xml',
			    Content => $xml);
if ($response->is_success) {
    print $response->content;  # or whatever
}
else {
    die $response->status_line;
}
