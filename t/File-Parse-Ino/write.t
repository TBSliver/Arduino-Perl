use strict;
use warnings;

use FindBin qw/ $Bin /;
use lib "$Bin/../../lib";

use File::Parse::Ino;

use File::Temp;
use IO::All;
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
  //something should go here
}

char* testtwo(char* mine) {
  char* carrot = 'a';
}
EOF

my $expected = <<EOF;
#include "Arduino.h"
#include <stdio.h>
#include "Serial.h"

#define CHEESE 5

int test(int poop, int balls);
void main(void);
char* testtwo(char* mine);

void main(void) {
  int balls = 5;
  return 0;
}

int test(int poop, int balls) {
  //something should go here
}

char* testtwo(char* mine) {
  char* carrot = 'a';
}
EOF

my $fh = File::Temp->new();

my $ino = File::Parse::Ino->new(
  program => $input,
  path    => $fh->filename,
);

my $output = $ino->write;

is($output, $fh->filename, "Filename as expected from output");

my $file_output = io($output)->slurp;

is($file_output, $expected, "Ino parsed output as expected");

done_testing;
