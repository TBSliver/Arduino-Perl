use strict;
use warnings;

use FindBin qw/ $Bin /;
use lib "$Bin/../../lib";

use File::Parse::Ino;

use Test::More;

my $input = <<EOF;
#include <stdio.h>
#include "Serial.h"

#define CHEESE 5

char* testtwo(char* mine);

void main(void) {
  int balls = 5;
  return 0;
}

int test(int poop, int balls) {
  //something shoudl go here
}

char* testtwo(char* mine) {
  char* carrot = 'a';
}
EOF

my $ino = File::Parse::Ino->new(
  program => $input,
  path    => '/usr/local',
);

my $output = $ino->_get_prototypes();

my $expected = [
  "int test(int poop, int balls)",
  "void main(void)"
];

is_deeply($output, $expected, "Prototypes as Expected");

done_testing;
