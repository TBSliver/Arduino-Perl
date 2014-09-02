use strict;
use warnings;

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";

use File::Parse::Ino::Remove qw/ remove_preprocessors /;

use Test::More;

my $input = <<EOF;
testing

#define TEST thing

#include <stdio.h>

more testing

#include "more/things.h"

again testing
EOF

my $expected = <<EOF;
testing



more testing


again testing
EOF

my $got = remove_preprocessors( $input );

is( $got, $expected, "Preprocessors stripped as expected");

done_testing;
