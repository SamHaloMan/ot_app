#!C:\Strawberry\perl\bin\perl
use CGI;
use JSON;
use CGI::Carp qw( fatalsToBrowser ); 
use lib qw(..);

use JSON qw( );
use Text::CSV_XS;
use Time::Piece;
use Time::Seconds;
use strict;
use warnings;
use Excel::Writer::XLSX;
use Encode qw(decode encode);
use File::Copy;
#our $dataPath="E:/TPE_DataCenter/ATS_Weekly_Report/PTB_team/data/";
#our $csvPath="E:/TPE_DataCenter/ATS_Weekly_Report/PTB_team/data/";
#our $jsnDataPath = "E:/TPE_DataCenter/ATS_Weekly_Report/PTB_team/data/";
#our $csvDataPath = "E:/TPE_DataCenter/ATS_Weekly_Report/PTB_team/OT_weekly/";

our $dataPath="E:/TPE_DataCenter/ATS_Weekly_Report/PTB_team/data/";
our $csvPath="E:/ATS_DataCenter/Management/PTB/PTB_AST1_RD_Overtime/";
our $jsnDataPath = "E:/TPE_DataCenter/ATS_Weekly_Report/PTB_team/data/";
our $csvDataPath = "E:/ATS_DataCenter/Management/PTB/PTB_AST1_RD_Overtime/";

sub formatWriteOut 
{ 
    my( $fp, $jD ) = @_; 
    print $fp "\t{\n";
    print $fp "\t\t\"id\":\"$jD->{'id'}\",\n";
    print $fp "\t\t\"ApplyDate\":\"$jD->{'ApplyDate'}\",\n";
    print $fp "\t\t\"Applicant\":\"$jD->{'Applicant'}\",\n";
    print $fp "\t\t\"ApplicantID\":\"$jD->{'ApplicantID'}\",\n";
    print $fp "\t\t\"Project\":\"$jD->{'Project'}\",\n";
    print $fp "\t\t\"OTStart\":\"$jD->{'OTStart'}\",\n";
    print $fp "\t\t\"OTEnd\":\"$jD->{'OTEnd'}\",\n";
    print $fp "\t\t\"PlannedOTHrs\":\"$jD->{'PlannedOTHrs'}\",\n";
	print $fp "\t\t\"Summary\":\"$jD->{'Summary'}\",\n";
    print $fp "\t\t\"OTTask\":\"$jD->{'OTTask'}\",\n";
    print $fp "\t\t\"ExpectedResult\":\"$jD->{'ExpectedResult'}\",\n";
    print $fp "\t\t\"ActualOTEnd\":\"$jD->{'ActualOTEnd'}\",\n";
    print $fp "\t\t\"ActualOTHrs\":\"$jD->{'ActualOTHrs'}\",\n";
    print $fp "\t\t\"ReasonAddtlHrs\":\"$jD->{'ReasonAddtlHrs'}\"\n";
    print $fp "\t}";
}

# Create a new CGI object
my $cgi = CGI->new;

# Parse JSON data
our $postData = $cgi->param('POSTDATA');
our $jData = decode_json($postData);
our $output = "NONE";

# Retrieve date for filename
my $fileDate=substr($jData->{'ApplyDate'},0,6);
my $filename = $dataPath.$fileDate."OT.json";    # would be ../data/202308OT.json

if (-e $filename) {
    # Backup original data
        #system("cp $filename $filename.bak 2>/dev/null");
		copy($filename, "$filename.bak");

    # Read data from original file
        my $json_text = do {
           open(my $json_fh, "<:encoding(UTF-8)", $filename)
              or die("Can't open \"$filename\": $!\n");
           local $/;
           <$json_fh>
        };
        my $json = JSON->new;
        my $fJdata = $json->decode($json_text)->{'PTBOTList'};

    # Write back to file
        open my $fh, ">", $filename;
            print $fh "{\"PTBOTList\":[\n";
             for my $key (@$fJdata) {
                if($key->{'id'}!=$jData->{'id'}) {
                    formatWriteOut($fh, $key);
                    print $fh ",\n";
                }                
             }
            formatWriteOut($fh, $jData);
            print $fh "\n]}\n";
        close $fh;

    # Returned message
        $output="$jData->{'id'} is saved.";
        
} else {
    # Write to file
        open my $fh, ">", $filename;
            print $fh "{\"PTBOTList\":[\n";
                formatWriteOut($fh, $jData);
            print $fh "\n]}\n";
        close $fh;

    # Returned message
        $output="$jData->{'id'} is created.";
}

# Response json
my $out = {
    "data"=>$jData,
    "result"=>$output
};

# Convert data to JSON format
my $json_content = encode_json($out);

# Set the content type to JSON
print $cgi->header(-type => 'application/json');

# Print the JSON content
print $json_content;



########################################################################################

# Read data from original file again
my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", $filename)
      or die("Can't open \"$filename\": $!\n");
   local $/;
   <$json_fh>
};
my $json = JSON->new;
my $fJdata = $json->decode($json_text)->{'PTBOTList'};


# # Open the CSV file for writing
# my $csv_file = $csvPath.$fileDate."OT.csv";
# open my $fr, ">", $csv_file;

# # Write CSV header
# print $fr "Date,Name,Project,OT Start,OT End,OT Hours,OT Task,Expected Result,Actual End,Actual Hour,Reason\n";

# # Write data to CSV
# for my $key (@$fJdata) {
    # my $tmpY=substr($key->{'ApplyDate'},0,4);
    # my $tmpM=substr($key->{'ApplyDate'},4,2);
    # my $tmpD=substr($key->{'ApplyDate'},6,2);
    # print $fr "\"$tmpY/$tmpM/$tmpD\",=\"$key->{'Applicant'}\",=\"$key->{'Project'}\",";
    # print $fr "$key->{'OTStart'},$key->{'OTEnd'},$key->{'PlannedOTHrs'},";
    # print $fr "=\"$key->{'OTTask'}\",=\"$key->{'ExpectedResult'}\",";
    # print $fr "$key->{'ActualOTEnd'},$key->{'ActualOTHrs'},=\"$key->{'ReasonAddtlHrs'}\"";
    # print $fr "\n";
# }

# # Close the CSV file
# close $fr;

my $jsonObj = { PTBOTList=> [] };
my $appDate = Time::Piece -> strptime("$jData->{ApplyDate}","%Y%m%d");

my $filename = join "", $jsnDataPath, $appDate->year, sprintf("%02d",$appDate->mon), "OT.json";

my $csvFilename = join "",$csvDataPath, $appDate->year, sprintf("%02d",$appDate->mon), sprintf("%02d",$appDate->mday), "OT.xlsx";
my $csvOTSummary = join "",$csvDataPath, $appDate->year, sprintf("%02d",$appDate->mon), sprintf("%02d",$appDate->mday), "OTSummary.xlsx";
my $summaryDate = join "", $appDate->year, sprintf("%02d",$appDate->mon), sprintf("%02d",$appDate->mday);

if (-e $filename) {
	my $json_text = do {
	   open(my $json_fh, "<:encoding(UTF-8)", $filename)
		  or die("Can't open \"$filename\": $!\n");
	   local $/;
	   <$json_fh>
	};

	my $json = JSON->new;
	$json_text =~ s/<<BR>>/\\n/g;
	my $otData = $json->decode($json_text);

	for $a( @{$otData->{PTBOTList}} ) {
		my $applyDate = Time::Piece -> strptime("$a->{ApplyDate}","%Y%m%d");
		if (($appDate->epoch == $applyDate->epoch)) {
			push @{ $jsonObj->{"PTBOTList"} }, $a;
		}
	}
}

#my $csv = "Text::CSV_XS"->new({ binary => 1, eol => "\n" });
#open my $OUT, ">:encoding(UTF-8)", $csvFilename or die $!;
#$csv->print($OUT, ["","PTB AST1 RD Overtime Log"]);
#$csv->print($OUT, ["Date", "Project", "RD", "Overtime Task", "Expected Result", "Planned OT(hrs)",
#					"Planned Tap out", "Actual OT(hrs)", "Actual Tap Out", "Reason for addt\'l hrs"]);
#$csv->print($OUT, [ @$_{qw{ ApplyDate Project Applicant OTTask ExpectedResult PlannedOTHrs
#					OTEnd ActualOTHrs ActualOTEnd ReasonAddtlHrs}} ]) for @{$jsonObj->{"PTBOTList"}};
#close $OUT or die $!;

my $workbook = Excel::Writer::XLSX->new($csvFilename);
my $worksheet = $workbook->add_worksheet();
my $chDateToday = join "", $appDate->year, " 年 ", sprintf("%02d",$appDate->mon), " 月 ", sprintf("%02d",$appDate->mday), " 日 ";
my $chDay = uc $appDate->fullday;
$worksheet->set_column("A:A", 4.14);
$worksheet->set_column("B:B", 13.43);
$worksheet->set_column("C:C", 21.14);
$worksheet->set_column("D:D", 22.29);
$worksheet->set_column("E:E", 22.86);
$worksheet->set_column("F:F", 10.14);
$worksheet->set_column("G:G", 15.14);
$worksheet->set_column("H:H", 13.57);
$worksheet->set_column("I:I", 15.71);
$worksheet->set_column("J:J", 1.00);
$worksheet->set_column("K:K", 17.14);
$worksheet->set_column("L:L", 14.43);
$worksheet->set_column("M:M", 15.43);
$worksheet->set_column("N:N", 18.57);

$worksheet->set_row(0, 30);
$worksheet->merge_range("A1:N1", decode("utf8", "Form Lembur (加 班 申 请 单)"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"20"));
$worksheet->set_row(1, 80);
$worksheet->merge_range("A2:C2", decode("utf8", "Departemen\n(部门代码)：\nK390140R1C\nBG6-RD Center-Automatic System Test R&D Div.1-Dept.1-PTB Sec.1"), $workbook->add_format(valign=>"left", align=>"vcenter", font=>"Arial", size=>"11"));
$worksheet->write("D2", decode("utf8", "Klasifikasi Karyawan\n(人员分类):"), $workbook->add_format(valign=>"right", align=>"vcenter", font=>"Arial", size=>"11"));
$worksheet->write("E2", decode("utf8", "☐ Band0(1-2職等)\n☑ Band1(3-5職等)"), $workbook->add_format(valign=>"left", align=>"vcenter", font=>"Arial", size=>"11"));
$worksheet->merge_range("F2:H2", decode("utf8", "Tanggal Lembur （加班日期）:\n                           $chDateToday \n Hari （星期）: $chDay"), $workbook->add_format(valign=>"left", align=>"vcenter", font=>"Arial", size=>"11"));
$worksheet->merge_range("I2:N2", decode("utf8", "Jenis Lembur （加班类别） :\n☑ Saat Hari Kerja (工作日延长加班) \n☐ Saat Hari Libur (休息日加班) \n☐ Saat Tanggal Merah (法定假日加班)"), $workbook->add_format(valign=>"left", align=>"vcenter", font=>"Arial", size=>"11"));

$worksheet->set_row(2, 92);
$worksheet->write("A3", decode("utf8", "No"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
$worksheet->write("B3", decode("utf8", "No Karyawan\n(工号)"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
$worksheet->write("C3", decode("utf8", "Nama\n(姓名)"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
$worksheet->write("D3", decode("utf8", "Alasan Lembur\n(申请加班事由)"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
$worksheet->write("E3", decode("utf8", "Jam Lembur (Waktu)\n(预计加班\n起止时间)"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
$worksheet->write("F3", decode("utf8", "Durasi Lembur\n(预计加班时数)"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
$worksheet->write("G3", decode("utf8", "Jam istirahat saat lembur (jika perlu, gunakan V)\n(预计休息或用餐打V)"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
$worksheet->write("H3", decode("utf8", "Tanda Tangan Karyawan\n(员工签名)"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
$worksheet->write("I3", decode("utf8", "Tanda Tangan Supervisor\n(课级主管签名)"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
$worksheet->write("K3", decode("utf8", "Konfirmasi Jam Lembur (Waktu)\n(实际加班           \n起止时间)"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
$worksheet->write("L3", decode("utf8", "Konfirmasi Durasi Lembur\n(实际加班时数)"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
$worksheet->write("M3", decode("utf8", "Jam Istirahat (Jika ada, gunakan V)\n(实际休息或用餐打V)"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
$worksheet->write("N3", decode("utf8", "Tanda Tangan Karyawan\n(员工签名)"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));

my $count=4;
my @loop = (1..30);
for ( @loop ) {
	$worksheet->write("A$count", $count-3, $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"12", border=>"1"));
	$worksheet->write("B$count", "", $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
	$worksheet->write("C$count", "", $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
	$worksheet->write("D$count", "", $workbook->add_format(valign=>"left", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
	$worksheet->write("E$count", "", $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
	$worksheet->write("F$count", "", $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
	$worksheet->write("G$count", "", $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
	$worksheet->write("H$count", "", $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
	$worksheet->write("I$count", "", $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
	$worksheet->write("K$count", "", $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
	$worksheet->write("L$count", "", $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
	$worksheet->write("M$count", "", $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
	$worksheet->write("N$count", "", $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));	
	$count = $count+1;
}

my $realOTHrs=0;
$count=4;
for $b( @{$jsonObj->{PTBOTList}} ) {
	#$worksheet->write("A$count", $count-3, $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"10", border=>"1"));
	$worksheet->write("B$count", decode("utf8", "$b->{ApplicantID} "), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
	$worksheet->write("C$count", decode("utf8", "$b->{Applicant} "), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
	$worksheet->write("D$count", decode("utf8", "$b->{Summary} "), $workbook->add_format(valign=>"left", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
	$worksheet->write("E$count", decode("utf8", "$b->{OTStart} - $b->{OTEnd}"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
	$worksheet->write("F$count", decode("utf8", "$b->{PlannedOTHrs} hour(s)"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
	$worksheet->write("G$count", decode("utf8", "-"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
	#$worksheet->write("H$count", decode("utf8", "Tanda Tangan Karyawan\n(员工签名)"), $workbook->add_format(valign=>"center", align=>"vcenter"));
	#$worksheet->write("I$count", decode("utf8", "Tanda Tangan Supervisor\n(课级主管签名)"), $workbook->add_format(valign=>"center", align=>"vcenter"));
	$worksheet->write("K$count", decode("utf8", "$b->{OTStart} - $b->{ActualOTEnd}"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
	$realOTHrs=$b->{ActualOTHrs};
	if (($appDate->wday == 7)||($appDate->wday == 1)) {
		if ( $realOTHrs > 5 ){
			$realOTHrs = $realOTHrs - 1;
			$worksheet->write("L$count", decode("utf8", "$realOTHrs hour(s)"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
		} elsif ( ($realOTHrs >= 4) && ($realOTHrs <= 5 ) ) {
			$worksheet->write("L$count", decode("utf8", "4 hour(s)"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
		} else {
			$worksheet->write("L$count", decode("utf8", "$b->{ActualOTHrs} hour(s)"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
		}
	} else {
		if ( $realOTHrs > 4.5 ){
			$realOTHrs = $realOTHrs - .5;
			$worksheet->write("L$count", decode("utf8", "$realOTHrs hour(s)"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
		} elsif ( ($realOTHrs >= 4) && ($realOTHrs <= 4.5) ) {
			$worksheet->write("L$count", decode("utf8", "4 hour(s)"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
		} else {
			$worksheet->write("L$count", decode("utf8", "$b->{ActualOTHrs} hour(s)"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
		}
	}
	$worksheet->write("M$count", decode("utf8", "-"), $workbook->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"1"));
	#$worksheet->write("N$count", decode("utf8", "Tanda Tangan Karyawan\n(员工签名)"), $workbook->add_format(valign=>"center", align=>"vcenter"));	
	$count = $count+1;
}

$worksheet->merge_range("A34:N34", decode("utf8", "Keterangan："), $workbook->add_format(valign=>"left", align=>"vcenter", font=>"Arial", size=>"12"));
$worksheet->merge_range("A35:N35", decode("utf8", "1、Informasi diatas harus dilaporkan dengan benar, pelanggaran akan dikenakan sesuai dengan hukuman yang ada dari managemen perusahaan \n( 以上资料请据实申报，违者按奖惩管理办法处理)。"), $workbook->add_format(valign=>"left", align=>"vcenter", font=>"Arial", size=>"12"));
$worksheet->merge_range("A36:N36", decode("utf8", "2、Karyawan harus menandatangani aplikasi lembur. Jika tidak ada tanda tangan maka akan di anggap tidak sah (实际加班时数，以员工签名确认为准)。"), $workbook->add_format(valign=>"left", align=>"vcenter", font=>"Arial", size=>"12"));
$worksheet->merge_range("A37:N37", decode("utf8", "3、Tidak ada aplikasi lembur tidak akan di hitung untuk upah lembur (无加班申请单不计发加班费)。"), $workbook->add_format(valign=>"left", align=>"vcenter", font=>"Arial", size=>"12"));
$worksheet->write("M38", decode("utf8", "Form No.:PTB-TB004-001 Rev.01"), $workbook->add_format(valign=>"left", align=>"vcenter", font=>"Arial", size=>"10"));

$workbook->close();

# FOR OT Summary excel file
my $bookSummary = Excel::Writer::XLSX->new($csvOTSummary);
my $sheetsummary = $bookSummary->add_worksheet();

$sheetsummary->set_column("A:A", 11.5);
$sheetsummary->set_column("B:B", 15.50);
$sheetsummary->set_column("C:C", 21.00);
$sheetsummary->set_column("D:D", 9.75);
$sheetsummary->set_column("E:E", 9.75);
$sheetsummary->set_column("F:F", 9.75);
$sheetsummary->set_column("G:G", 6.00);
$sheetsummary->set_column("H:H", 25.00);

$sheetsummary->write("A1", decode("utf8", "Work ID"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
$sheetsummary->write("B1", decode("utf8", "Overtime Type"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
$sheetsummary->write("C1", decode("utf8", "Overtime Start Date"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
$sheetsummary->write("D1", decode("utf8", "Start Time"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
$sheetsummary->write("E1", decode("utf8", "End Time"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
$sheetsummary->write("F1", decode("utf8", "Meal/Rest"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
$sheetsummary->write("G1", decode("utf8", "Hours"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
$sheetsummary->write("H1", decode("utf8", "Reason"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));


$count=2;
for $b( @{$jsonObj->{PTBOTList}} ) {
	$sheetsummary->write("A$count", decode("utf8", "$b->{ApplicantID}"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
	$sheetsummary->write("C$count", decode("utf8", "$summaryDate"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
	$sheetsummary->write("D$count", decode("utf8", "$b->{OTStart}"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
	$sheetsummary->write("E$count", decode("utf8", "$b->{ActualOTEnd}"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
	
	$realOTHrs=$b->{ActualOTHrs};
	if (($appDate->wday == 7)||($appDate->wday == 1)) {
		$sheetsummary->write("B$count", decode("utf8", "2"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
		if ( $realOTHrs > 5 ){
			$realOTHrs = $realOTHrs - 1;
			$sheetsummary->write("F$count", decode("utf8", "Y"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
			$sheetsummary->write("G$count", decode("utf8", "$realOTHrs"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
		} elsif ( ($realOTHrs >= 4) && ($realOTHrs <= 5 ) ) {
			$sheetsummary->write("F$count", decode("utf8", "N"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
			$sheetsummary->write("G$count", decode("utf8", "4.0"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
		} else {
			$sheetsummary->write("F$count", decode("utf8", "N"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
			$sheetsummary->write("G$count", decode("utf8", "$b->{ActualOTHrs}"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
		}
	} else {
		$sheetsummary->write("B$count", decode("utf8", "1"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
		if ( $realOTHrs > 4.5 ){
			$realOTHrs = $realOTHrs - .5;
			$sheetsummary->write("F$count", decode("utf8", "N"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
			$sheetsummary->write("G$count", decode("utf8", "$realOTHrs "), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
		} elsif ( ($realOTHrs >= 4) && ($realOTHrs <= 4.5) ) {
			$sheetsummary->write("F$count", decode("utf8", "N"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
			$sheetsummary->write("G$count", decode("utf8", "4.0"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
		} else {
			$sheetsummary->write("F$count", decode("utf8", "N"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
			$sheetsummary->write("G$count", decode("utf8", "$b->{ActualOTHrs}"), $bookSummary->add_format(valign=>"center", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
		}
	}
	$sheetsummary->write("H$count", decode("utf8", "$b->{Summary}"), $bookSummary->add_format(valign=>"left", align=>"vcenter", font=>"Arial", size=>"11", border=>"0"));
	$count = $count+1;
}

$bookSummary->close();