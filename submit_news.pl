#!/usr/local/bin/perl

use strict;
use DBI;
use CGI;

#### read in config ####
open (CONFIG,$config);
my @config = <CONFIG>;
my @line = split(":",$config[0]);
my $online_file = $line[1];
@line = split(":",$config[1]);
my $credential_file = $line[1];
close(CONFIG);
#### END CONFIG ####

#### database credentials ####
open(CRED,$credential_file);
my @creds = <CRED>;
@line = split(":", $creds[0]);
my $database = $line[1];
@line = split(":",$creds[1]);
my $username = $line[1];
@line = split(":",$creds[2]);
my $password = $line[1];
close(CRED);
#### END CREDENTIALS #####

my $q = CGI->new();

my $the_news = $q->param('the_news');

my $dbh = DBI->connect("dbi:Pg:dbname=$database",$username,$password) or die "Database connection failed in submit_news.pl";
my $query = "insert into news (news) values ('$the_news')";
my $sth = $dbh->prepare($query) or die "couldn't prepare query";
$sth->execute or die "couldn't execute statement";

print "Content-type: text/html\n\n";
print "All good champ.  If not talk to bels, he was slacking when he wrote this in the first place. Click <a href=\"http://www.aethyraproject.org\">here</a> to go back to the main site and look at the shinies";