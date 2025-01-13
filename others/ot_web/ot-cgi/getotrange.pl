#!C:\Strawberry\perl\bin\perl
use CGI;
use JSON;
use CGI::Carp qw( fatalsToBrowser ); 
use lib qw(..);

use JSON qw( );
use Text::CSV_XS;
use Time::Piece;

BEGIN 
{ 
	sub carp_error 
	{ 
		my $error_message = shift; 
		my $q = new CGI; 
		my $discard_this = $q->header( "text/html" ); 
		error( $q, $error_message ); 
	} 
	CGI::Carp::set_message( \&carp_error ); 
} 

sub error 
{ 
	my( $q, $error_message ) = @_; 
	print $q->header( "text/html" ), 
		$q->start_html( "Error" ), 
		$q->h1( "Error" ), 
		$q->p( "Sorry, the following error has occurred: " ), 
		$q->p( $q->i( $error_message ) ), 
		$q->end_html; 
	exit; 
}

		
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
my $nowHHMM = sprintf("%02d%02d", $hour, $min);

# Create a new CGI object
my $cgi = CGI->new;

# Retrieve POST parameters
my $data = $cgi->param("POSTDATA");

# Parse JSON data
my $jsnDataPath = "E:/TPE_DataCenter/ATS_Weekly_Report/PTB_team/data/";
my $jData = decode_json($data);
my $jsonObj = { PTBOTList=> [] };

print $cgi->header("application/json");

my $sDate = Time::Piece -> strptime("$jData->{startDate}","%Y%m%d");
my $eDate = Time::Piece -> strptime("$jData->{endDate}","%Y%m%d");
my $sYear = $sDate->year;
my $sMon = sprintf("%02d", $sDate->mon);
my $sDay = sprintf("%02d", $sDate->mday);
my $eYear = $eDate->year;
my $eMon = sprintf("%02d", $eDate->mon);
my $eDay = sprintf("%02d", $eDate->mday);

if ($sYear > $eYear){
	print "Invalid Start/End Year";
	exit;
} elsif (($sYear == $eYear)&&($sMon > $eMon)) {
	print "Invalid Start/End Month";
	exit;
} elsif (($sYear == $eYear)&&($sMon == $eMon)&&($sDay > $eDay)) {
	print "Invalid Start/End Day";
	exit;
}

my @yearRange = ($sYear..$eYear);

for (@yearRange){
	my @monthRange = ();
	my $cYear = $_;
	if ($cYear == $eYear){
		if ($sYear == $eYear) {
			@monthRange = ($sMon..$eMon);
		} else {
			@monthRange = (1..$eMon);
		}
	} else {
		@monthRange = ($sMon..12);
	}

	for $i (@monthRange){
		my $filename = join "", $jsnDataPath, $cYear, sprintf("%02d",$i), "OT.json";

		if (-e $filename) {
			my $json_text = do {
			   open(my $json_fh, "<:encoding(UTF-8)", $filename)
				  or die("Can't open \"$filename\": $!\n");
			   local $/;
			   <$json_fh>
			};

			my $json = JSON->new;
			my $otData = $json->decode($json_text);

			for $a( @{$otData->{PTBOTList}} ) {
				my $applyDate = Time::Piece -> strptime("$a->{ApplyDate}","%Y%m%d");
				if (($sDate->epoch <= $applyDate->epoch)&&($eDate->epoch >= $applyDate->epoch)) {
					push @{ $jsonObj->{"PTBOTList"} }, $a;
				}
			}
		}
	}
}

print encode_json($jsonObj);