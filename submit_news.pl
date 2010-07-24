#!/usr/local/bin/perl

use strict;
use DBI;
use CGI;

my $q = CGI->new();

my $the_news = $q->param('the_news');

my $dbh = DBI->connect("dbi:Pg:dbname=aethyra","aethyra","PAssword1234") or die "Database connection failed in submit_news.pl";
my $query = "insert into news (news) values ('$the_news')";
my $sth = $dbh->prepare($query) or die "couldn't prepare query";
$sth->execute or die "couldn't execute statement";

print "Content-type: text/html\n\n";
print "All good champ.  If not talk to bels, he was slacking when he wrote this in the first place. Click <a href=\"http://www.aethyraproject.org\">here</a> to go back to the main site and look at the shinies";