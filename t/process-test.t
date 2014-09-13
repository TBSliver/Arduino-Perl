use strict;
use warnings;

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";

use File::Parse::Ino;
use IO::All;
use File::Temp;
use Test::More;

my @test_file_prefixes = ( 
  'Baladuino',
  'CharWithEscapedDoubleQuote',
  'IncludeBetweenMultilineComment',
  'LineContinuations',
  'RemoteCallLogger_v1e0',
  'StringWithCcomment',
);

my $test_file_folder = "$Bin/etc/preproc-test/";

for my $test_file_prefix (@test_file_prefixes) {
  test_files($test_file_folder, $test_file_prefix);
}

sub test_files {
  my $folder_prefix = shift;
  my $file_prefix = shift;

  my $original_filename = $folder_prefix . $file_prefix . ".ino";
  my $stripped_filename = $folder_prefix . $file_prefix . ".processed.ino";

  my $original_io = io($original_filename);
  my $original_slurp = $original_io->slurp;

  my $output_fh = File::Temp->new(DIR => "$Bin/tmp");
  my $output_filename = $output_fh->filename;

  my $ino = File::Parse::Ino->new(
    program => $original_slurp,
    path => $output_filename
  );

  my $stripped_io = io($stripped_filename);
  my $stripped_slurp = $stripped_io->slurp;

  my $output_io = io($ino->write);
  my $output_slurp = $output_io->slurp;
  

  is($output_slurp, $stripped_slurp, "$file_prefix has been processed correctly");

}

done_testing;
