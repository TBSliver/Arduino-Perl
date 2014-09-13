use strict;
use warnings;

use FindBin qw/ $Bin /;
use lib "$Bin/../../lib";

use File::Parse::Ino::Remove qw/ get_first_statement_index /;

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

my $got = get_first_statement_index( $input );
my $expected = 58;

is( $got, $expected, "First statement index as expected");

done_testing;
