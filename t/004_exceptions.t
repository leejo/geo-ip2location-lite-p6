#!perl6

use Test;
use Geo::IP2Location::Lite;

plan 4;

my $good_file = 'samples/IP-COUNTRY-SAMPLE.BIN';
my $obj = Geo::IP2Location::Lite.new;
$obj.open( $good_file );

is( $obj.get_country_short( 'foo' ),'INVALID IP ADDRESS',"lookup with bad IP" );
is( $obj.get_country_short( '0.0.3.4' ),'-',"lookup with missing IP" );
is( $obj.get_country_short( '255.255.255.254' ),'??',"lookup with not covered IP" );

is(
	$obj.get_latitude( '0.0.3.4' ),
	'This parameter is unavailable in selected .BIN data file. Please upgrade data file.',
	'data unsupported function'
);

done-testing;
