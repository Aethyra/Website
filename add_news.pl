#!/usr/local/bin/perl

use strict;
use Template;
use DBI;

my @styles = ("styles/styles.css");
my @javascripts = ();

my $vars = {'title' => 'Aethyra Project - Add News','styles' => \@styles,'javascripts' => \@javascripts};

my $file = "add_news.tt";

print "Content-type: text/html\n\n";

my $template = Template->new();
$template->process($file,$vars) || die $template->error();