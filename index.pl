#!/usr/local/bin/perl

use strict;
use Template;
use DBI;

my @styles = ("styles/styles.css");
my @javascripts = ();

#### get online players #####
open (ONLINE,"/usr/local/eathena/online.txt");
my @array = <ONLINE>;
my $online = pop(@array);
chomp $online;
close(ONLINE);
#####################

my $dbh = DBI->connect("dbi:Pg:dbname=aethyra","aethyra","PAssword1234") or die "Database connection failed in index";
my $query = "select * from news order by entered DESC limit 3";
my $sth = $dbh->prepare($query);
$sth->execute;
my $results = $sth->fetchall_arrayref;

my $row = @$results[0];

my $news1 = @$row[1];
my $news1_date = @$row[2];
$row = @$results[1];
my $news2 = @$row[1];
my $news2_date = @$row[2];
$row = @$results[2];
my $news3 = @$row[1];
my $news3_date = @$row[2];

my $vars = {'title' => 'Aethyra Project',,'styles' => \@styles,'javascripts' => \@javascripts,'online_players' => $online,'news1' => $news1,'news2' => $news2,'news2' => $news2,'news1_date' => $news1_date,'news2_date' => $news2_date,'news2_date' => $news2_date};

my $file = "index.tt";

print "Content-type: text/html\n\n";

my $template = Template->new();
$template->process($file,$vars) || die $template->error();