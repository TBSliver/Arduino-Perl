package File::Parse::Ino::Remove;

use strict;
use warnings;

use Exporter qw/ import /;

our @EXPORT_OK = qw/
get_first_statement_index
remove_comments
remove_preprocessors
remove_char_literals
remove_string_literals
remove_nested_braces
remove_all
/;

our %EXPORT_TAGS = ( all => \@EXPORT_OK );

use C::Tokenize qw/ $comment_re
                    $cpp_re
                    $char_const_re
                    $string_re /;

use Regexp::Common qw/ balanced /;

sub get_first_statement_index {
  my $string = shift;

  my $regex = $comment_re . "|" . $cpp_re . "|" . "\\s+";

  $string =~ m/($regex)*/g;

  # @+ special variable is the last index of the match
  my $index = $+[0];

  return $index;
}

sub remove_comments {
  return _remove_part(shift, $comment_re);
}

sub remove_preprocessors {
  return _remove_part(shift, $cpp_re);
}

sub remove_char_literals {
  return _remove_part(shift, $char_const_re);
}

sub remove_string_literals {
  return _remove_part(shift, $string_re);
}

sub remove_nested_braces {
  return _remove_part(shift, $RE{balanced}{-parens => '{}'}, '{}');
}

sub remove_all {
  my $string = shift;
  my $ret_string;

  # The order here actually matters, incase there are URLs inside a string,
  # instead of a comment.

  $ret_string = remove_preprocessors(   $string );
  $ret_string = remove_char_literals(   $ret_string );
  $ret_string = remove_string_literals( $ret_string );
  $ret_string = remove_comments(        $ret_string );
  $ret_string = remove_nested_braces(   $ret_string );
  return $ret_string;
}

sub _remove_part {
  my $string = shift;
  my $regex = shift;
  my $replacement = shift;
  $replacement ||= "";
  
  $string =~ s/$regex/$replacement/g;

  return $string;
}

1;
