use strict;
use warnings;

use FindBin qw/ $Bin /;
use lib "$Bin/../../lib";

use File::Parse::Ino::Remove qw/ remove_nested_braces /;

use Test::More;

my $input = <<EOF;
testing

{this is a test thing}

{ this is an internal }more testing{ tester }

{ this is more
  {internal multiline }
testing }

again testing
EOF

my $expected = <<EOF;
testing

{}

{}more testing{}

{}

again testing
EOF

my $got = remove_nested_braces( $input );

is( $got, $expected, "Nested braces stripped as expected");

done_testing;
