#
# Given a folder, the script will look for all xml files with the name format Strings_XXX.xml 
# and will generate a binary file in the input folder
#

use File::Basename;
use File::stat;

if ($#ARGV + 1 != 4) {
	die("Wrong arguments # ".$#ARGV."\n.");
}

print "StringTool Path: ".$ARGV[0]."\n";
print "StringTool Script Path: ".$ARGV[1]."\n";
print "Processing xml files in folder: ".$ARGV[2]."\n";
print "Output data to: ".$ARGV[3]."\n";

$stringToolPath = $ARGV[0];
$stringToolScriptPath = $ARGV[1];

@inputFiles = <$ARGV[2]/Strings_*.xml>;

open ($FILE_DATALIB, ">".$ARGV[3]) or die "cannot open lib for output.";
binmode $FILE_DATALIB;

#write the data lib header
print $FILE_DATALIB (pack "a7", "DATALIB");

#write the file count
print $FILE_DATALIB (pack "L", (scalar @inputFiles));

$index = 0;

# TODO
# IF NOT EXIST "%ProjectPath%\data\gl2\strings\EN_US" mkdir "%ProjectPath%\data\gl2\strings\EN_US"
# "%GameToolkitPath%\bin\StringTool\StringTool.exe" -input "%ProjectPath%\data\gl2\strings\Strings_EN_US.xml" -script "%ProjectPath%\tools\StringTool\StringScript_AS30_ByteArray_Lang.csl" -output "%ProjectPath%\data\gl2\strings\EN_US"

@processedFiles = ();

# processing the input binary files and fill the sprlib FAT :)
foreach $inputFile (@inputFiles) 
{
  ($name,$path,$suffix) = fileparse($inputFile, ".xml");

  $result = ($name =~ m/^\Strings_([\S]+)/ig);
  $langTag = $1;

  unless ($result) {
	  next;
  }

  print "lang tag: ".$1."\n";
    
  unless (-d "$ARGV[2]/$langTag") 
  {
	  mkdir "$ARGV[2]/$langTag", 0755;
  }
  
  # convert the xmls to binary and output the results (.bin and .hx) to the newly created folders
  $result = `$stringToolPath -input $inputFile -script $stringToolScriptPath -output "$ARGV[2]/$langTag"`;
  print $result;

  @binFiles = <$ARGV[2]/$langTag/*.bin>;

  foreach $binFileName (@binFiles) {
	  $fileSize = (stat($binFileName)->size);

	  #print $binFileName." - ".$fileSize."\n";
	  
	  #write the size
	  print $FILE_DATALIB (pack "L", ($fileSize));

	  push(@processedFiles, $binFileName);
  }
  
  $index = $index + 1;
}

foreach $binFileName (@processedFiles) {
  my $buffer;

  # read the input file
  open ($BINFILE, $binFileName) or die "cannot open input " . $binFileName;
  binmode $BINFILE;

  print "copy to langlib: ".$binFileName."\n";

  while (
    read ($BINFILE, $buffer, 65536)	# read in (up to) 64k chunks, write
    and print ($FILE_DATALIB $buffer)	# exit if read or write fails
  ) {};

  #die "Problem copying: $!\n" if $!;

  close ($BINFILE);
}

print "Processed " . ($index) . " languages and ".(scalar @processedFiles)." binary language files.\n";

close ($FILE_DATALIB);
