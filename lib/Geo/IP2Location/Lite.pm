unit module Geo::IP2Location::Lite;

use NativeCall;

$Geo::IP2Location::Lite::VERSION = '0.08';

class Geo::IP2Location::Lite {

	subset IPv4 of Str where / (\d ** 1..3) ** 4 % '.' /;
	has %!file;

	submethod BUILD( Str :$file ) {
		%!file{"filehandle"} = open( $file, :bin );

		%!file{"databasetype"}      = self!read8(%!file{"filehandle"}, 1);
		%!file{"databasecolumn"}    = self!read8(%!file{"filehandle"}, 2);
		%!file{"databaseyear"}      = self!read8(%!file{"filehandle"}, 3);
		%!file{"databasemonth"}     = self!read8(%!file{"filehandle"}, 4);
		%!file{"databaseday"}       = self!read8(%!file{"filehandle"}, 5);
		%!file{"ipv4databasecount"} = self!read32(%!file{"filehandle"}, 6);
		%!file{"ipv4databaseaddr"}  = self!read32(%!file{"filehandle"}, 10);
		%!file{"ipv4indexbaseaddr"} = self!read32(%!file{"filehandle"}, 22);
	}

	my $UNKNOWN            = "UNKNOWN IP ADDRESS";
	my $INVALID_IP_ADDRESS = "INVALID IP ADDRESS";
	my $NOT_SUPPORTED      = "This parameter is unavailable in selected .BIN data file. Please upgrade data file.";
	my $MAX_IPV4_RANGE     = 4294967295;

	my $COUNTRYSHORT       = 1;
	my $COUNTRYLONG        = 2;
	my $REGION             = 3;
	my $CITY               = 4;
	my $ISP                = 5;
	my $LATITUDE           = 6;
	my $LONGITUDE          = 7;
	my $DOMAIN             = 8;
	my $ZIPCODE            = 9;
	my $TIMEZONE           = 10;
	my $NETSPEED           = 11;
	my $IDDCODE            = 12;
	my $AREACODE           = 13;
	my $WEATHERSTATIONCODE = 14;
	my $WEATHERSTATIONNAME = 15;
	my $MCC                = 16;
	my $MNC                = 17;
	my $MOBILEBRAND        = 18;
	my $ELEVATION          = 19;
	my $USAGETYPE          = 20;

	my $NUMBER_OF_FIELDS   = 20;
	my $ALL                = 100;

	my %POSITIONS = (
		$COUNTRYSHORT       => [0,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2],
		$COUNTRYLONG        => [0,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2],
		$REGION             => [0,  0,  0,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3],
		$CITY               => [0,  0,  0,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4],
		$LATITUDE           => [0,  0,  0,  0,  0,  5,  5,  0,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5],
		$LONGITUDE          => [0,  0,  0,  0,  0,  6,  6,  0,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6],
		$ZIPCODE            => [0,  0,  0,  0,  0,  0,  0,  0,  0,  7,  7,  7,  7,  0,  7,  7,  7,  0,  7,  0,  7,  7,  7,  0,  7],
		$TIMEZONE           => [0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  8,  8,  7,  8,  8,  8,  7,  8,  0,  8,  8,  8,  0,  8],
		$ISP                => [0,  0,  3,  0,  5,  0,  7,  5,  7,  0,  8,  0,  9,  0,  9,  0,  9,  0,  9,  7,  9,  0,  9,  7,  9],
		$DOMAIN             => [0,  0,  0,  0,  0,  0,  0,  6,  8,  0,  9,  0, 10,  0, 10,  0, 10,  0, 10,  8, 10,  0, 10,  8, 10],
		$NETSPEED           => [0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  8, 11,  0, 11,  8, 11,  0, 11,  0, 11,  0, 11],
		$IDDCODE            => [0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  9, 12,  0, 12,  0, 12,  9, 12,  0, 12],
		$AREACODE           => [0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 10, 13,  0, 13,  0, 13, 10, 13,  0, 13],
		$WEATHERSTATIONCODE => [0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  9, 14,  0, 14,  0, 14,  0, 14],
		$WEATHERSTATIONNAME => [0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 10, 15,  0, 15,  0, 15,  0, 15],
		$MCC                => [0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  9, 16,  0, 16,  9, 16],
		$MNC                => [0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 10, 17,  0, 17, 10, 17],
		$MOBILEBRAND        => [0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 11, 18,  0, 18, 11, 18],
		$ELEVATION          => [0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 11, 19,  0, 19],
		$USAGETYPE          => [0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 12, 20],
	);

	method !get_by_pos ( IPv4 $ipaddr, Int $pos ) {
		my $ipnum = :256[$ipaddr.comb(/\d+/)]; # convert ipv4 to int!
		return self!get_record( $ipnum,$pos )
	}

	method get_module_version { return $Geo::IP2Location::Lite::VERSION }

	method get_database_version {
		return %!file{"databaseyear"} ~ "." ~ %!file{"databasemonth"} ~ "." ~ %!file{"databaseday"};
	}

	method get_country            ( IPv4 $ip ) { return ( self!get_by_pos( $ip,$COUNTRYSHORT ),self!get_by_pos( $ip,$COUNTRYLONG ) ) }
	method get_country_short      ( IPv4 $ip ) { return self!get_by_pos( $ip,$COUNTRYSHORT ); }
	method get_country_long       ( IPv4 $ip ) { return self!get_by_pos( $ip,$COUNTRYLONG ); }
	method get_region             ( IPv4 $ip ) { return self!get_by_pos( $ip,$REGION ); }
	method get_city               ( IPv4 $ip ) { return self!get_by_pos( $ip,$CITY ); }
	method get_isp                ( IPv4 $ip ) { return self!get_by_pos( $ip,$ISP ); }
	method get_latitude           ( IPv4 $ip ) { return self!get_by_pos( $ip,$LATITUDE ); }
	method get_zipcode            ( IPv4 $ip ) { return self!get_by_pos( $ip,$ZIPCODE ); }
	method get_longitude          ( IPv4 $ip ) { return self!get_by_pos( $ip,$LONGITUDE ); }
	method get_domain             ( IPv4 $ip ) { return self!get_by_pos( $ip,$DOMAIN ); }
	method get_timezone           ( IPv4 $ip ) { return self!get_by_pos( $ip,$TIMEZONE ); }
	method get_netspeed           ( IPv4 $ip ) { return self!get_by_pos( $ip,$NETSPEED ); }
	method get_iddcode            ( IPv4 $ip ) { return self!get_by_pos( $ip,$IDDCODE ); }
	method get_areacode           ( IPv4 $ip ) { return self!get_by_pos( $ip,$AREACODE ); }
	method get_weatherstationcode ( IPv4 $ip ) { return self!get_by_pos( $ip,$WEATHERSTATIONCODE ); }
	method get_weatherstationname ( IPv4 $ip ) { return self!get_by_pos( $ip,$WEATHERSTATIONNAME ); }
	method get_mcc                ( IPv4 $ip ) { return self!get_by_pos( $ip,$MCC ); }
	method get_mnc                ( IPv4 $ip ) { return self!get_by_pos( $ip,$MNC ); }
	method get_mobilebrand        ( IPv4 $ip ) { return self!get_by_pos( $ip,$MOBILEBRAND ); }
	method get_elevation          ( IPv4 $ip ) { return self!get_by_pos( $ip,$ELEVATION ); }
	method get_usagetype          ( IPv4 $ip ) { return self!get_by_pos( $ip,$USAGETYPE ); }

	method get_all ( IPv4 $ip ) {
		my @res = self!get_by_pos( $ip,$ALL );

		if @res[0] eq $INVALID_IP_ADDRESS {
			return ( $INVALID_IP_ADDRESS x $NUMBER_OF_FIELDS );
		}

		return @res;
	}

	method !get_record ( Int $ipnum, Int $mode ) {
		my $dbtype= %!file{"databasetype"};

		if ( $mode != $ALL ) {
			if ( %POSITIONS{$mode}[$dbtype] == 0 ) {
				return $NOT_SUPPORTED;
			}
		}
		
		my $realipno = $ipnum;
		my $handle = %!file{"filehandle"};
		my $baseaddr = %!file{"ipv4databaseaddr"};
		my $dbcount = %!file{"ipv4databasecount"};
		my $dbcolumn = %!file{"databasecolumn"};
		my $indexbaseaddr = %!file{"ipv4indexbaseaddr"};

		my $ipnum1_2 = $ipnum +> 16;
		my $indexaddr = $indexbaseaddr + ($ipnum1_2 +< 3);

		my $low = 0;
		my $high = $dbcount;

		if $indexbaseaddr > 0 {
			$low = self!read32($handle, $indexaddr);
			$high = self!read32($handle, $indexaddr + 4);
		}

		my $mid = 0;
		my $ipfrom = 0;
		my $ipto = 0;
		my $ipno = 0;

		if ($realipno == $MAX_IPV4_RANGE) {
			$ipno = $realipno - 1;
		} else {
			$ipno = $realipno;
		}

		while ($low <= $high) {
			$mid = ($low + $high) +> 1;
			$ipfrom = self!read32($handle, $baseaddr + $mid * $dbcolumn * 4);
			$ipto = self!read32($handle, $baseaddr + ($mid + 1) * $dbcolumn * 4);
			if (($ipno >= $ipfrom) && ($ipno < $ipto)) {

				my @return_vals;

				my @modes = $mode == $ALL
					?? ( $COUNTRYSHORT .. $NUMBER_OF_FIELDS )
					!! $mode;

				for @modes -> $pos {

					if ( %POSITIONS{$pos}[$dbtype] == 0 ) {
						push( @return_vals, $NOT_SUPPORTED );
					} else {
						if ( $pos == $LATITUDE or $pos == $LONGITUDE ) {

							push( @return_vals, sprintf( "%.6f",self!readFloat(
								$handle,
								$baseaddr + ( $mid * $dbcolumn * 4 ) + 4 * ( %POSITIONS{$pos}[$dbtype] -1 )
							) ) ); 

						} elsif ( $pos == $COUNTRYLONG ) {

							my $return_val = self!readStr(
								$handle,
								self!read32( $handle,$baseaddr + ( $mid * $dbcolumn * 4 ) + 4 * ( %POSITIONS{$pos}[$dbtype] -1 ) ) +3
							);

							push( @return_vals, $return_val );

						} else {

							my $return_val = self!readStr(
								$handle,
								self!read32( $handle,$baseaddr + ( $mid * $dbcolumn * 4 ) + 4 * ( %POSITIONS{$pos}[$dbtype] -1 ) )
							);

							if ( $pos == $COUNTRYSHORT && $return_val eq 'UK' ) {
								$return_val = 'GB';
							}

							push( @return_vals,$return_val );
						}
					}
				}

				return ( $mode == $ALL ) ?? @return_vals !! @return_vals[0];

			} else {
				if ($ipno < $ipfrom) {
					$high = $mid - 1;
				} else {
					$low = $mid + 1;
				}
			}
		}

		return $UNKNOWN;
	}

	method !read32 ( IO::Handle $handle, Int $position ) {
		$handle.seek($position-1, SeekFromBeginning);
		my $data = $handle.read(4);
		return nativecast((int32), Blob.new($data));
	}

	method !read8 ( IO::Handle $handle, Int $position ) {
		$handle.seek($position-1, SeekFromBeginning);
		my $data = $handle.read(1);
		return nativecast((int8), Blob.new($data));
	}

	method !readStr ( IO::Handle $handle, Int $position ) {
		$handle.seek($position, SeekFromBeginning);
		my $data = $handle.read(1);
		my $return_val = $handle.read(nativecast((int8), Blob.new($data)));
		return $return_val.decode;
	}

	method !readFloat ( IO::Handle $handle, Int $position ) {
		$handle.seek($position-1, SeekFromBeginning);
		my $data = $handle.read(4);

		my sub is-little-endian returns Bool {
		    my $i = CArray[uint32].new: 0x01234567;
		    my $j = nativecast(CArray[uint8], $i);
		    return $j[0] == 0x67;
		}

		return is-little-endian()
			?? return nativecast((num32), Blob.new($data))
			!! return nativecast((num32), Blob.new($data.reverse));
	}

}
