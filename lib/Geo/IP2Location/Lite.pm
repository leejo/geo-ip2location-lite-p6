unit module Geo::IP2Location::Lite;

# Copyright (C) 2005-2014 IP2Location.com
# All Rights Reserved
#
# This library is free software: you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; If not, see <http://www.gnu.org/licenses/>.

use experimental :pack;

$Geo::IP2Location::Lite::VERSION = '0.08';

class Geo::IP2Location::Lite {

	has %!obj;

	my $UNKNOWN            = "UNKNOWN IP ADDRESS";
	my $NO_IP              = "MISSING IP ADDRESS";
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

	my $IPv4_re = / (\d ** 1..3) ** 4 % '.' /;


	method open( Str $db_file ) {
		%!obj{"filehandle"} = open( $db_file, :bin );

		%!obj{"databasetype"} = self.read8(%!obj{"filehandle"}, 1);
		%!obj{"databasecolumn"} = self.read8(%!obj{"filehandle"}, 2);
		%!obj{"databaseyear"} = self.read8(%!obj{"filehandle"}, 3);
		%!obj{"databasemonth"} = self.read8(%!obj{"filehandle"}, 4);
		%!obj{"databaseday"} = self.read8(%!obj{"filehandle"}, 5);
		%!obj{"ipv4databasecount"} = self.read32(%!obj{"filehandle"}, 6);
		%!obj{"ipv4databaseaddr"} = self.read32(%!obj{"filehandle"}, 10);
		%!obj{"ipv4indexbaseaddr"} = self.read32(%!obj{"filehandle"}, 22);
	}

	method _get_by_pos ( Str $ipaddr, Int $pos ) {
		return $INVALID_IP_ADDRESS
			if ! $pos;

		my ( $ipv,$ipnum ) = self.validate_ip( $ipaddr );

		return $ipv == 4
			?? self.get_record( $ipnum,$pos )
			!! $INVALID_IP_ADDRESS;
	}

	method get_module_version { return $Geo::IP2Location::Lite::VERSION }

	method get_database_version {
		return %!obj{"databaseyear"} ~ "." ~ %!obj{"databasemonth"} ~ "." ~ %!obj{"databaseday"};
	}

	method get_country            ( Str $ip ) { return ( self._get_by_pos( $ip,$COUNTRYSHORT ),self._get_by_pos( $ip,$COUNTRYLONG ) ) }
	method get_country_short      ( Str $ip ) { return self._get_by_pos( $ip,$COUNTRYSHORT ); }
	method get_country_long       ( Str $ip ) { return self._get_by_pos( $ip,$COUNTRYLONG ); }
	method get_region             ( Str $ip ) { return self._get_by_pos( $ip,$REGION ); }
	method get_city               ( Str $ip ) { return self._get_by_pos( $ip,$CITY ); }
	method get_isp                ( Str $ip ) { return self._get_by_pos( $ip,$ISP ); }
	method get_latitude           ( Str $ip ) { return self._get_by_pos( $ip,$LATITUDE ); }
	method get_zipcode            ( Str $ip ) { return self._get_by_pos( $ip,$ZIPCODE ); }
	method get_longitude          ( Str $ip ) { return self._get_by_pos( $ip,$LONGITUDE ); }
	method get_domain             ( Str $ip ) { return self._get_by_pos( $ip,$DOMAIN ); }
	method get_timezone           ( Str $ip ) { return self._get_by_pos( $ip,$TIMEZONE ); }
	method get_netspeed           ( Str $ip ) { return self._get_by_pos( $ip,$NETSPEED ); }
	method get_iddcode            ( Str $ip ) { return self._get_by_pos( $ip,$IDDCODE ); }
	method get_areacode           ( Str $ip ) { return self._get_by_pos( $ip,$AREACODE ); }
	method get_weatherstationcode ( Str $ip ) { return self._get_by_pos( $ip,$WEATHERSTATIONCODE ); }
	method get_weatherstationname ( Str $ip ) { return self._get_by_pos( $ip,$WEATHERSTATIONNAME ); }
	method get_mcc                ( Str $ip ) { return self._get_by_pos( $ip,$MCC ); }
	method get_mnc                ( Str $ip ) { return self._get_by_pos( $ip,$MNC ); }
	method get_mobilebrand        ( Str $ip ) { return self._get_by_pos( $ip,$MOBILEBRAND ); }
	method get_elevation          ( Str $ip ) { return self._get_by_pos( $ip,$ELEVATION ); }
	method get_usagetype          ( Str $ip ) { return self._get_by_pos( $ip,$USAGETYPE ); }

	method get_all ( Str $ip ) {
		my @res = self._get_by_pos( $ip,$ALL );

		if @res[0] eq $INVALID_IP_ADDRESS {
			return ( $INVALID_IP_ADDRESS x $NUMBER_OF_FIELDS );
		}

		return @res;
	}

	method get_record ( Int $ipnum, Int $mode ) {
		my $dbtype= %!obj{"databasetype"};

		if ($ipnum eq "") {
			if ($mode == $ALL) {
				return ( $NO_IP x $NUMBER_OF_FIELDS );
			} else {
				return $NO_IP;
			}
		}

		if ( $mode != $ALL ) {
			if ( %POSITIONS{$mode}[$dbtype] == 0 ) {
				return $NOT_SUPPORTED;
			}
		}
		
		my $realipno = $ipnum;
		my $handle = %!obj{"filehandle"};
		my $baseaddr = %!obj{"ipv4databaseaddr"};
		my $dbcount = %!obj{"ipv4databasecount"};
		my $dbcolumn = %!obj{"databasecolumn"};
		my $indexbaseaddr = %!obj{"ipv4indexbaseaddr"};

		my $ipnum1_2 = $ipnum +> 16;
		my $indexaddr = $indexbaseaddr + ($ipnum1_2 +< 3);

		my $low = 0;
		my $high = $dbcount;

		if $indexbaseaddr > 0 {
			$low = self.read32($handle, $indexaddr);
			$high = self.read32($handle, $indexaddr + 4);
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
			$ipfrom = self.read32($handle, $baseaddr + $mid * $dbcolumn * 4);
			$ipto = self.read32($handle, $baseaddr + ($mid + 1) * $dbcolumn * 4);
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

							push( @return_vals, sprintf( "%.6f",self.readFloat(
								$handle,
								$baseaddr + ( $mid * $dbcolumn * 4 ) + 4 * ( %POSITIONS{$pos}[$dbtype] -1 )
							) ) ); 

						} elsif ( $pos == $COUNTRYLONG ) {

							my $return_val = self.readStr(
								$handle,
								self.read32( $handle,$baseaddr + ( $mid * $dbcolumn * 4 ) + 4 * ( %POSITIONS{$pos}[$dbtype] -1 ) ) +3
							);

							$return_val = $return_val.unpack( "A*" );
							push( @return_vals, $return_val );

						} else {

							my $return_val = self.readStr(
								$handle,
								self.read32( $handle,$baseaddr + ( $mid * $dbcolumn * 4 ) + 4 * ( %POSITIONS{$pos}[$dbtype] -1 ) )
							);

							$return_val = $return_val.unpack( "A*" );
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

	method read32 ( IO::Handle $handle, Int $position ) {
		$handle.seek($position-1, SeekFromBeginning);
		my $data = $handle.read(4);
		return Blob.new( $data ).unpack("V");
	}

	method read8 ( IO::Handle $handle, Int $position ) {
		$handle.seek($position-1, SeekFromBeginning);
		my $data = $handle.read(1);
		return Blob.new($data).unpack("C");
	}

	method readStr ( IO::Handle $handle, Int $position ) {
		$handle.seek($position, SeekFromBeginning);
		my $data = $handle.read(1);
		return $handle.read(Blob.new($data).unpack("C"));
	}

	method readFloat ( IO::Handle $handle, Int $position ) {
		$handle.seek($position-1, SeekFromBeginning);
		my $data = $handle.read(4);

		my $is_little_endian = pack('N',123456789).unpack('V') == 123456789
			?? False !! True;

		if $is_little_endian {
			# "LITTLE ENDIAN - x86\n";
			return Blob.new($data).unpack("f");
		} else {
			# "BIG ENDIAN - MAC\n";
			return Blob.new(reverse($data)).unpack("f");
		}
	}

	method validate_ip ( Str $ip ) {
		my $ipv = -1;
		my $ipnum = -1;
		
		if self.ip_is_ipv4($ip) {
			#ipv4 address
			$ipv = 4;
			$ipnum = self.ip2no($ip);
		}
		return ($ipv, $ipnum);
	}

	method ip2no ( Str $ip ) {
		my @block = split(/\./, $ip);
		my $no = 0;
		$no = @block[3];
		$no = $no + @block[2] * 256;
		$no = $no + @block[1] * 256 * 256;
		$no = $no + @block[0] * 256 * 256 * 256;
		return $no;
	}

	method ip_is_ipv4 ( Str $ip ) {
		if $ip ~~ $IPv4_re {
			return True;
		} else {
			return False;
		}
	}

}
