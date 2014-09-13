package File::Parse::Ino::Get;

use strict;
use warnings;

use Exporter qw/ import /;

our @EXPORT_OK = qw/
get_first_statement_index
/;

our %EXPORT_TAGS = ( all => \@EXPORT_OK );

use C::Tokenize qw/ $comment_re
                    $cpp_re /;

sub get_first_statement_index {
  my $string = shift;

  my $regex = $comment_re . "|" . $cpp_re . "|" . "\\s+";

  $string =~ m/($regex)*/g;

  # @+ special variable is the last index of the match
  my $index = $+[0];

  return $index;
}


