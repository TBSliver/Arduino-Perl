use strict;
use warnings;

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";

use File::Parse::Ino::Remove qw/ remove_char_literals /;

use Test::More;

my $input = <<EOF;
testing

'3'

'a'more testing'e'

'a' 'b' 'c' 'd'

again testing
EOF

# Yes, there is bare whitespace in this....
my $expected = <<EOF;
testing



more testing

   

again testing
EOF

my $got = remove_char_literals( $input );

is( $got, $expected, "Char literals stripped as expected");

done_testing;
