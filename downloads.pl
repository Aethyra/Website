#!/usr/local/bin/perl

use strict;
use Template;
use DBI;

my @styles = ("styles/styles.css");
my @javascripts = ();

my $vars = {'title' => 'Aethyra Project - Downloads','styles' => \@styles,'javascripts' => \@javascripts};

my $file = "downloads.tt";

print "Content-type: text/html\n\n";

my $template = Template->new();
$template->process($file,$vars) || die $template->error();