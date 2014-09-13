use strict;
use warnings;

use FindBin qw/ $Bin /;
use lib "$Bin/../../lib";

use File::Parse::Ino::Get qw/ get_import_targets /;
use IO::All;
use Test::More;

my %test_file_prefixes = (
  'Baladuino' => [
    'Balanduino.h',
    'Wire.h',
    'usbhub.h',
    'adk.h',
    'Kalman.h',
    'XBOXRECV.h',
    'SPP.h',
    'PS3BT.h',
    'Wii.h',
  ],
  'CharWithEscapedDoubleQuote' => [
    'SoftwareSerial.h',
    'Wire.h',
  ],
  'IncludeBetweenMultilineComment' => [
    'CapacitiveSensorDue.h',
  ],
  'LineContinuations' => [],
  'RemoteCallLogger_v1e0' => [
    'SoftwareSerial.h',
    'Wire.h',
  ],
  'StringWithCcomment' => [],
);

my $test_file_folder = "$Bin/../etc/preproc-test/";

for my $prefix (keys %test_file_prefixes) {
  test_files($test_file_folder, $prefix, $test_file_prefixes{$prefix});
}

sub test_files {
  my $folder_prefix = shift;
  my $file_prefix = shift;
  my $expected_output = shift;

  my $original_filename = $folder_prefix . $file_prefix . ".ino";

  my $original_io = io($original_filename);
  my $original_slurp = $original_io->slurp;

  my $output = get_import_targets($original_slurp);

  is_deeply($output, $expected_output, "$file_prefix has correct includes");

}

done_testing;
