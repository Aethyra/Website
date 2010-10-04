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
@line = split(":",$config[2]);
my $avatar_location = $line[1];
chomp($avatar_location);
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

my $dbh = DBI->connect("dbi:mysql:dbname=$database",$username,$password) or die "Database connection failed in index";
#my $query = "select * from news order by entered DESC limit 3";
my $query = "select phpbb_users.username, phpbb_users.user_avatar, phpbb_posts.post_subject, phpbb_posts.post_text, phpbb_posts.post_time FROM phpbb_posts INNER JOIN phpbb_users ON phpbb_posts.poster_id = phpbb_users.user_id where phpbb_posts.post_postcount = 1 and phpbb_posts.forum_id = 38 ORDER BY phpbb_posts.post_time DESC LIMIT 3";
my $sth = $dbh->prepare($query);
$sth->execute;
my $results = $sth->fetchall_arrayref;

#this should read in all the files in the directory specified in avatar location
my @avatars = <$avatar_location>;

my $row = @$results[0];

my $news1 = @$row[3];
my $news1_date = scalar localtime(@$row[4]);
my $news1_subject = @$row[2];
my $news1_poster = @$row[0];
my $news1_image;
#this method probably isn't the best way to do this because if there were a lot of files in the directory it could become slow and would get slower with more files.  We may never hit that situation.
foreach my $file (@avatars)
{
	#the forum stores the avatars in this format in the database: #inFileName_Random#.#fileExtensionOfFile
	#in the filesystem though the forum stores the avatar like this: DifferentRandom#_$inFileName.#fileExtension
	my @stuff = split("_",@$row[1]);
	my $extension = split(".",@stuff[1]);
	my $fileName = $stuff[0] . ".$extension";
	#this should now be #inFileName.#fileExtension example: 2.gif which should match a file listed in the filesystem (minus the random number but regexp takes care of the rest)
        if($file =~ /$fileName$/)
	{
		$news1_image = "forum/images/avatars/upload/$file";
	}
}
$row = @$results[1];
my $news2 = @$row[3];
my $news2_date = scalar localtime(@$row[4]);
my $news2_subject = @$row[2];
my $news2_poster = @$row[0];
my $news2_image;
foreach my $file (@avatars)
{
        #the forum stores the avatars in this format in the database: #inFileName_Random#.#fileExtensionOfFile
        #in the filesystem though the forum stores the avatar like this: DifferentRandom#_$inFileName.#fileExtension
        my @stuff = split("_",@$row[1]);
        my $extension = split(".",@stuff[1]);
        my $fileName = $stuff[0] . ".$extension";
        #this should now be #inFileName.#fileExtension example: 2.gif which should match a file listed in the filesystem (minus the random number but regexp
        if($file =~ /$fileName$/)
        {
                $news2_image = "forum/images/avatars/upload/$file";
        }
}
$row = @$results[2];
my $news3 = @$row[3];
my $news3_date = scalar localtime(@$row[4]);
my $news3_subject = @$row[2];
my $news3_poster = @$row[0];
my $news3_image;
foreach my $file (@avatars)
{
        #the forum stores the avatars in this format in the database: #inFileName_Random#.#fileExtensionOfFile
        #in the filesystem though the forum stores the avatar like this: DifferentRandom#_$inFileName.#fileExtension
        my @stuff = split("_",@$row[1]);
        my $extension = split(".",@stuff[1]);
        my $fileName = $stuff[0] . ".$extension";
        #this should now be #inFileName.#fileExtension example: 2.gif which should match a file listed in the filesystem (minus the random number but regexp
        if($file =~ /$fileName$/)
        {
                $news3_image = "forum/images/avatars/upload/$file";
        }
}

my $vars = {'title' => 'Aethyra Project','styles' => \@styles,'javascripts' => \@javascripts,'online_players' => $online,'news1' => $news1,'news2' => $news2,'news2' => $news2,'news1_date' => $news1_date,'news2_date' => $news2_date,'news2_date' => $news2_date, 'news1_image' => $news1_image, 'news2_image' => $news2_image, 'news3_image' => $news3_image, 'news1_poster' => $news1_poster, 'news2_poster' => $news2_poster, 'news3_poster' => $news3_poster, 'news1_subject' => $news1_subject, 'news2_subject' => $news2_subject, 'news3_subject' => $news3_subject};

my $file = "index.tt";

print "Content-type: text/html\n\n";

my $template = Template->new();
$template->process($file,$vars) || die $template->error();
