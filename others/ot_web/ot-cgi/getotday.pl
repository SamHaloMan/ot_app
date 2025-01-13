#!C:\Strawberry\perl\bin\perl
use CGI;
use JSON;
use CGI::Carp qw( fatalsToBrowser ); 
use lib qw(..);

use JSON qw( );
use Text::CSV_XS;

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

my $otDataObj = {
			id=>"",
			ApplyDate=>"",
			Applicant=>"",
			ApplicantID=>"",
			Project=>"",
			OTStart=>"",
			OTEnd=>"",
			PlannedOTHrs=>"",
			Summary=>"",
			OTTask=>"",
			ExpectedResult=>"",
			ActualOTEnd=>"",
			ActualOTHrs=>"",
			ReasonAddtlHrs=>""
		};
		
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
my $nowHHMM = sprintf("%02d%02d", $hour, $min);

# Create a new CGI object
my $cgi = CGI->new;

# Retrieve POST parameters
my $data = $cgi->param("POSTDATA");

# Parse JSON data
my $jsnDataPath = "E:/TPE_DataCenter/ATS_Weekly_Report/PTB_team/data/";
my $jData = decode_json($data);

print $cgi->header("application/json");

$otDataObj->{ApplicantID} = $jData->{ApplicantID};
$otDataObj->{ApplyDate} = $jData->{ApplyDate};
#$otDataObj->{id} = "$jData->{ApplyDate}$nowHHMM$jData->{ApplicantID}";

my $fileDate = substr($jData->{ApplyDate}, 0, 6);
my $filename = join "", $jsnDataPath, $fileDate, "OT.json";
my $employee = join "", $jsnDataPath, "employee.json";

my $emp_text = do {
   open(my $emp_fh, "<:encoding(UTF-8)", $employee)
	  or die("Can't open \"$employee\": $!\n");
   local $/;
   <$emp_fh>
};

my $json = JSON->new;
my $empData = $json->decode($emp_text);

for ( @{$empData->{employee}} ) {
	if ($_->{id} eq $otDataObj->{ApplicantID}) {
		$otDataObj->{id} = "$jData->{ApplyDate}$nowHHMM$_->{EMPID}";
		last;
	}
}


if (-e $filename) {
	my $json_text = do {
	   open(my $json_fh, "<:encoding(UTF-8)", $filename)
		  or die("Can't open \"$filename\": $!\n");
	   local $/;
	   <$json_fh>
	};

	my $otData = $json->decode($json_text);

	for ( @{$otData->{PTBOTList}} ) {
		if (($_->{ApplicantID} eq $jData->{ApplicantID}) && ($_->{ApplyDate} eq $jData->{ApplyDate})) {
			$otDataObj->{id} = $_->{id};
			$otDataObj->{Applicant} = $_->{Applicant};
			$otDataObj->{Project} = $_->{Project};
			$otDataObj->{ApplyDate} = $_->{ApplyDate};
			$otDataObj->{OTStart} = $_->{OTStart};
			$otDataObj->{OTEnd} = $_->{OTEnd};
			$otDataObj->{PlannedOTHrs} = $_->{PlannedOTHrs};
			$otDataObj->{Summary} = $_->{Summary};
			$otDataObj->{OTTask} = $_->{OTTask};
			$otDataObj->{ExpectedResult} = $_->{ExpectedResult};
			$otDataObj->{ActualOTEnd} = $_->{ActualOTEnd};
			$otDataObj->{ActualOTHrs} = $_->{ActualOTHrs};
			$otDataObj->{ReasonAddtlHrs} = $_->{ReasonAddtlHrs};
			last;
		}
	}
}

print encode_json($otDataObj);


