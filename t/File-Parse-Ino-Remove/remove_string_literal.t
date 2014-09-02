use strict;
use warnings;

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";

use File::Parse::Ino::Remove qw/ remove_string_literals /;

use Test::More;

my $input = <<EOF;
testing

"this is a test thing"

"this is an internal"more testing"tester"

"this is a multi" "part test"

again testing
EOF

my $expected = <<EOF;
testing

more testing

again testing
EOF

my $got = remove_string_literals( $input );

is( $got, $expected, "String literals stripped as expected");

done_testing;
