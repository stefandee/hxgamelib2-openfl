#
# Given a folder, the script will look for all xml files with the name format Strings_XXX.xml 
# and will generate a binary file in the input folder
#

use File::Basename;
use File::stat;
use Crypt::RC4;

if ($#ARGV + 1 < 4) {
	die("Wrong arguments # ".$#ARGV."\n.");
}

print "Blacklist file: ".$ARGV[0]."\n";
print "PBL Template file: ".$ARGV[1]."\n";
print "PBL Final Class file: ".$ARGV[2]."\n";
print "RC4 Key: ".$ARGV[3]."\n";
print "Package: ".$ARGV[4]."\n";

# open for input
open($FILE_BLACKLIST, "<".$ARGV[0]) or die "cannot open ".$ARGV[0];

# read file into list
my(@blacklist) = <$FILE_BLACKLIST>; 
close($FILE_BLACKLIST);

$haxeArray = "";

$blacklistCount = $#blacklist;
$i = 0;

foreach $entry (@blacklist) 
{
	$i += 1;

	$entry =~ s/\n//g;
	$entry =~ s/\r//g;

	if (length($entry) == 0) {
		next;
	}
	
	$ref3 = Crypt::RC4->new( $ARGV[3] );
	$rc4Entry = $ref3->RC4($entry);
	#$rc4Entry = $entry;

	#print $entry." - ".length($rc4Entry)."\n";

	# convert to a string of hex 
	#$rc4Entry =~ s/(.)/sprintf("%X",ord($1))/eg;
	$rc4Entry = unpack( 'H*', $rc4Entry );

	#$rc4Entry =~ s/([a-fA-F0-9][a-fA-F0-9])/chr(hex($1))/eg;

	#$ref2 = Crypt::RC4->new( $ARGV[3] );
	#$rc4Entry = $ref2->RC4( $rc4Entry );	

	#print $entry." - ".$rc4Entry."\n";

	if ($i <= $blacklistCount) {
		$haxeArray = $haxeArray."\"".$rc4Entry."\"".", ";
	}
	else
	{
		$haxeArray = $haxeArray."\"".$rc4Entry."\"";
	}

	#print $entry." - ".$rc4Entry."\n";
}

# open the template PBL class file
open ($FILE_PBLTEMPLATE, $ARGV[1]) or die ("Cannot open input ".$ARGV[1]);
$pblTemplate = join("", <$FILE_PBLTEMPLATE>);
close($FILE_PBLTEMPLATE);

# replace the data and the key
$pblTemplate =~ s/%LIST%/$haxeArray/g;
$pblTemplate =~ s/%KEY%/$ARGV[3]/g;

# open the output PBL class file
open ($OUTFILE, ">".$ARGV[2]) or die ("Cannot open ".$ARGV[2]);

if (length($ARGV[4]) > 0) {
	print $OUTFILE "package ".$ARGV[4].";\r\n\r\n";
}

print $OUTFILE $pblTemplate;
close($OUTFILE);
