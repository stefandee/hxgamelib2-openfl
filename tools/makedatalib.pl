use File::Basename;
use File::stat;

if ($#ARGV + 1 != 6) {
	die("Not enough arguments.");
}

print "data folder: ".$ARGV[0]."\n";
print "output data lib: ".$ARGV[1]."\n";
print "haxe interface: ".$ARGV[2]."\n";
print "files to add: ".$ARGV[3]."\n";
print "class name: ".$ARGV[4]."\n";
print "prefix: ".$ARGV[5]."\n";

@sprites = <$ARGV[0]/*.$ARGV[3]>;

open ($FILE_DATALIB, ">".$ARGV[1]) or die "cannot open sprite lib for output.";
binmode $FILE_DATALIB;

#write the sprite lib header
print $FILE_DATALIB (pack "a7", "DATALIB");

#write the file count
print $FILE_DATALIB (pack "L", (scalar @sprites));

open ($FILE_HAXE, ">".$ARGV[2]) or die "cannot open haxe interface for output.";
print $FILE_HAXE ("package data;\n\nclass ".$ARGV[4]."\n{\n");

$index = 0;

# processing the sprites files and fill the sprlib FAT :)
foreach $sprite (@sprites) 
{
  # read the input file
  open ($SPRFILE, $sprite) or die "cannot open input " . $sprite;

  #print $sprite." - ".stat($sprite)->size."\n";

  ($name,$path,$suffix) = fileparse($sprite,"\.".$ARGV[3]);

  print $FILE_HAXE ("\tpublic static var ".$ARGV[5]."_".uc($name)." = ".$index.";\n");

  #write the size
  print $FILE_DATALIB (pack "L", (stat($sprite)->size));

  $index = $index + 1;

  close ($SPRFILE);
}

# write the sprites to the sprlib
foreach $sprite (@sprites) 
{
  my $buffer;

  # read the input file
  open ($SPRFILE, $sprite) or die "cannot open input " . $sprite;
  binmode $SPRFILE;

  print "copy to spritelib: ".$sprite."\n";

  while (
    read ($SPRFILE, $buffer, 65536)	# read in (up to) 64k chunks, write
    and print ($FILE_DATALIB $buffer)	# exit if read or write fails
  ) {};

  #die "Problem copying: $!\n" if $!;

  close ($SPRFILE);
}

print "Processed " . (scalar @sprites) . " files.\n";

print $FILE_HAXE "}\n";

close ($FILE_DATALIB);
close ($FILE_HAXE);
