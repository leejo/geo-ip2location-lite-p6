# NAME

Geo::IP2Location::Lite - Lightweight lookup of IPv4 address details using BIN files from http://www.ip2location.com

<div>

    <a href='https://travis-ci.org/leejo/geo-ip2location-lite-p6?branch=master'><img src='https://travis-ci.org/leejo/geo-ip2location-lite-p6.svg?branch=master' alt='Build Status' /></a>
    <a href='https://coveralls.io/r/leejo/geo-ip2location-lite-p6?branch=master'><img src='https://coveralls.io/repos/leejo/geo-ip2location-lite-p6/badge.png?branch=master' alt='Coverage Status' /></a>
</div>

# SYNOPSIS

        #!perl6

        use Geo::IP2Location::Lite;

        my $obj = Geo::IP2Location::Lite.new(
                # required path to IP2Location BIN file
                file => "/path/to/IP-COUNTRY.BIN"
        );

        # IPv4 formatted address
        my $ip           = "20.11.187.239";

        my $countryshort = $obj.get_country_short( $ip );
        my $countrylong  = $obj.get_country_long( $ip );
        my $region       = $obj.get_region( $ip );
        my $city         = $obj.get_city( $ip );
        my $isp          = $obj.get_isp( $ip );
        my $zipcode      = $obj.get_zipcode( $ip );
        my $domain       = $obj.get_domain( $ip );
        my $timezone     = $obj.get_timezone( $ip );
        my $netspeed     = $obj.get_netspeed( $ip );
        my $iddcode      = $obj.get_iddcode( $ip );
        my $areacode     = $obj.get_areacode( $ip );
        my $ws_code      = $obj.get_weatherstationcode( $ip );
        my $ws_name      = $obj.get_weatherstationname( $ip );
        my $carrier_code = $obj.get_mcc( $ip );
        my $network_code = $obj.get_mnc( $ip );
        my $mobile_brand = $obj.get_mobilebrand( $ip );
        my $elevation    = $obj.get_elevation( $ip );
        my $usage_type   = $obj.get_usagetype( $ip );
        my $latitude     = $obj.get_latitude( $ip );
        my $longitude    = $obj.get_longitude( $ip );

        my ( $country_short,$country_long,$region,$city,... )
                = $obj.get_all("20.11.187.239");

# DESCRIPTION

This module allows you to lookup IPv4 details using the BIN files as sourced
from [http://www.ip2location.com](http://www.ip2location.com). Full usage is described in the SYNOPSIS
above. 

Note the module expects an IPv4 formatted address to be passed to all lookup
methods. Anything else will throw a type constraint error.

When constructing the object the file parameter is mandatory.

# SEE ALSO

[http://www.ip2location.com](http://www.ip2location.com)

# VERSION

0.10

# AUTHOR

Lee Johnson `leejo@cpan.org`. If you would like to contribute documentation,
features, bug fixes, or anything else then please raise an issue / pull request:

    https://github.com/leejo/geo-ip2location-lite-v6

# LICENSE

The Artistic License 2.0 (See LICENSE in github repo)
