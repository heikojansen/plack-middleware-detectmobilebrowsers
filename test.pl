#!/usr/bin/perl 

use strict;
use warnings;

use lib qw( Plack-Middleware-DetectMobileBrowsers/lib );

use Data::Dumper;
use Plack::Builder;

my $key = undef;
# $key = 'psgix.mobile_client';

my $app = sub {
	my $env = shift;

	my $response = '';

	my $ek = 'mobile_client';
	$ek = $key if defined $key;
		
	if ( $env->{$ek} ) {
		$response = "\nMOBILE CLIENT DETECTED\n\n";
	}
	else {
		$response = "\n_NO_ MOBILE CLIENT DETECTED\n\n";
	}

	$response .= Dumper($env);

	return [
		200,
		[ 'Content-Type' => 'text/plain' ],
		[ $response ]
	];
};

builder {
	if ( defined $key ) {
        enable 'DetectMobileBrowsers', env_key => $key, tablets_as_mobile => 0;
	}
	else {
		enable 'DetectMobileBrowsers', tablets_as_mobile => 1;
	}
	$app;
};

#
# Examples
#
# Mobile:
# curl -A 'Mozilla/5.0 (Linux; Android 4.0.4; Galaxy Nexus Build/IMM76B) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.133 Mobile Safari/535.19' http://0:5000/
#
# Tablet
# curl -A 'Mozilla/5.0 (Linux; Android 4.0.4; Galaxy Nexus Build/IMM76B) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.133 Safari/535.19' http://0:5000/
#
# Desktop:
# curl -A 'Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20100101 Firefox/18.0' http://0:5000/
#
