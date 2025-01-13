#!C:\Strawberry\perl\bin\perl
use strict;
use warnings;
use CGI;
use JSON;

my $cgi = CGI->new;
my $jsnDataPath = "E:/TPE_DataCenter/ATS_Weekly_Report/PTB_team/data/";
my $filename=$jsnDataPath."project.json";
my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", $filename)
      or die("Can't open \"$filename\": $!\n");
   local $/;
   <$json_fh>
};

# Set the content type to JSON
print $cgi->header(-type => "application/json");

# Print the JSON content
print $json_text;