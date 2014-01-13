#!/usr/bin/perl -w

#
# take an email file name as argument, parse it (puts html tags in it)
# and then change file permissions accordingly, and then goes one dir up
# ,and modify the email.html file, put a heading there etc..
#

use strict;

#require "util.pl";

die "This script needs an input email file name...\n" unless $ARGV[0];
my $email_file = $ARGV[0];
my $output_email_file = $email_file . ".html";

open (EMAIL_FILE, "<$email_file") or die "unable to open $email_file";
open (OUTFILE, ">$output_email_file") or die "unable to open $output_email_file";

my $Date = "";
my $Subject = "";
my $still_commenting = 1;

# first comment the html tags out, find the date and subject, check validity of email
print OUTFILE "<!-- commenting the email tags out .... \n";
while (my $l = <EMAIL_FILE>) {
	chomp $l;
#	print ($l);
	if ($still_commenting) {
		$l =~ s/\-+/-/g;
	#	print ("$l\n");
	}

	print OUTFILE ("$l\n");
	# check if this line contains Date: Tue, 9 Sep 2008 00:17:55 -0500 (CDT)
	if ($l =~ /^Date: (.+) (\d\d:\d\d):\d\d /) {
		die "Date should not be there ...\n" if $Date;
		$Date = $1 . ", " . $2;
#		$Date = $1;
	}
	# check if this line contains Subject: 2's complement -- just negatives or both positives and negatives?
	if ($l =~ /^Subject: (.+)$/) {
		die "Subject should not be there ...\n" if $Subject;
		$Subject = $1;
		$Subject =~ s/\-+/-/g;
		die "THere should be Date: header before Subject: header ...\n" unless $Date;
#		last;
		print OUTFILE "End comment here .... --> \n";
		# needed because the first line would <\font>
		print OUTFILE "<HTML>\n";
		print OUTFILE "<HEAD>\n";
		print OUTFILE "<TITLE>EE 460N: Email $Date</TITLE>\n";
		print OUTFILE "</HEAD>\n";
		print OUTFILE "<BODY TEXT=\"black\" BGCOLOR=\"white\" LINK=\"green\" VLINK=\"purple\" ALINK=\"#0000EE\">\n";

		print OUTFILE "<H1></H1>\n";
		print OUTFILE "<p><font size=+1>$Date</font>\n";
		print OUTFILE "<p><pre>\n";
		print OUTFILE "<font>\n";
		my $still_commenting = 0;
	}
}

	print ("Date: $Date \n");
	print ("Subject: $Subject\n");
print OUTFILE "</font>\n</pre>\n</body>\n</html>\n";

close (EMAIL_FILE);
close (OUTFILE);

system("chmod a+r $output_email_file");



system("cp -p ../email.html ../email.html_orig");
system("rm -rf ../email.html");

open (EMAIL_INDEX_FILE, "<../email.html_orig") or die "unable to open ../email.html_orig";
open (OUTFILE_EMAIL_INDEX_FILE, ">../email.html") or die "unable to open email.html";

while (my $l = <EMAIL_INDEX_FILE>) {
	chomp $l;
	print OUTFILE_EMAIL_INDEX_FILE ("$l\n");
	if ($l =~ /PLACE HOLDER: PLEASE DO NOT DELETE THIS LINE/) {
		print OUTFILE_EMAIL_INDEX_FILE "$Date&nbsp;&nbsp;\n";
		print OUTFILE_EMAIL_INDEX_FILE "<a href=\"Emails/$output_email_file\">$Subject</a>\n";
		print OUTFILE_EMAIL_INDEX_FILE "<br>\n";
		print OUTFILE_EMAIL_INDEX_FILE "\n";
#		last;
	}
}

# commented out because index.html is manually updated now from caproj account
#my $today_date = `date +%m/%d/%y`;
#chomp $today_date;
##print "$today_date\n";
#my $command  = "sed 's:\\(Email Archive.*last updated - \\)[0-9][0-9]/[0-9][0-9]/[0-9][0-9]:\\1$today_date:' < ../index.html > ../index_new.html";
##print "$command\n";
#system $command;
#system("chmod a+r ../index_new.html");
#system("chgrp ee306ta ../index_new.html");
#system("chmod g+w ../index_new.html");
#system("mv ../index_new.html ../index.html");
##print "$result\n";

close (EMAIL_INDEX_FILE);
close (OUTFILE_EMAIL_INDEX_FILE);


