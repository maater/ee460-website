#!/usr/bin/perl -w

use strict;


system("cp -p ../email.html ../email.html_orig");
system("rm -rf ../email.html");

open (EMAIL_INDEX_FILE, "<../email.html_orig") or die "unable to open ../email.html_orig";
open (OUTFILE_EMAIL_INDEX_FILE, ">../email.html") or die "unable to open email.html";
system("chmod a+r ../email.html");
#open (OUTFILE_EMAIL_INDEX_FILE, ">../email_test.html") or die "unable to open email_test.html";

while (my $line = <EMAIL_INDEX_FILE>) {
	chomp $line;
	if ($line =~ /(.+) 2008&nbsp/) {
		my $Date = $1 . " 2008";
		my $line2 = <EMAIL_INDEX_FILE>;
		$line2 =~ /a href="Emails\/(.+)">/;
		my $file = $1;
		print ("$file\n");
		open (EMAIL_FILE, "<$file") or die "unable to open $file";
		while (my $a = <EMAIL_FILE>) {
			if ($a =~ /^Date: (.+) (\d\d:\d\d):\d\d /) {
				$Date = $1 . ", " . $2;
			}
		}
		print ("$Date\n");
		print OUTFILE_EMAIL_INDEX_FILE "$Date&nbsp;&nbsp;\n";
		print OUTFILE_EMAIL_INDEX_FILE "$line2\n";
	}
	else {
		print OUTFILE_EMAIL_INDEX_FILE "$line\n";
	}
}

close (EMAIL_INDEX_FILE);
close (OUTFILE_EMAIL_INDEX_FILE);


