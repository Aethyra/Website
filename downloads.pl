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

my $vars = {'title' => 'Aethyra Project - Downloads','styles' => \@styles,'javascripts' => \@javascripts,'online_players' => $online};

my $file = "downloads.tt";

print "Content-type: text/html\n\n";

my $template = Template->new();
$template->process($file,$vars) || die $template->error();
