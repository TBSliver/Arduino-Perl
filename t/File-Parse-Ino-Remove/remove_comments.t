use strict;
use warnings;

use FindBin qw/ $Bin /;
use lib "$Bin/../../lib";

use File::Parse::Ino::Remove qw/ remove_comments /;

use Test::More;

my $input = <<EOF;
testing

/* test
 * of a multiline
 comment
 *****
 **/

more testing

// another comment

again testing
EOF

my $expected = <<EOF;
testing



more testing


again testing
EOF

my $got = remove_comments( $input );

is( $got, $expected, "Comments stripped as expected");

done_testing;
