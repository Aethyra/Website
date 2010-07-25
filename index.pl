#!/usr/local/bin/perl

use strict;
use Template;
use DBI;

my @styles = ("styles/styles.css");
my @javascripts = ();
my $config = "/var/aethyra/config";

#### read in config ####
open (CONFIG,$config);
my @config = <CONFIG>;
my @line = split(":",$config[0]);
my $online_file = $line[1];
chomp($online_file);
@line = split(":",$config[1]);
my $credential_file = $line[1];
chomp($credential_file);
close(CONFIG);
#### END CONFIG ####

#### get online players #####
open (ONLINE,$online_file);
my @array = <ONLINE>;
my $online = pop(@array);
chomp $online;
close(ONLINE);
#####################

#### database credentials ####
open(CRED,$credential_file);
my @creds = <CRED>;
@line = split(":", $creds[0]);
my $database = $line[1];
chomp($database);
@line = split(":",$creds[1]);
my $username = $line[1];
chomp($username);
@line = split(":",$creds[2]);
my $password = $line[1];
chomp($password);
close(CRED);
#### END CREDENTIALS #####

my $dbh = DBI->connect("dbi:Pg:dbname=$database",$username,$password) or die "Database connection failed in index";
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