package File::Parse::Ino::Remove;

use strict;
use warnings;

use Exporter qw/ import /;

our @EXPORT_OK = qw/
remove_comments
remove_preprocessors
remove_char_literals
remove_string_literals
remove_nested_braces
/;

our %EXPORT_TAGS = ( all => \@EXPORT_OK );

use C::Tokenize qw/ $comment_re
                    $cpp_re
                    $char_const_re
                    $string_re /;

use Regexp::Common qw/ balanced /;

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

sub _remove_part {
  my $string = shift;
  my $regex = shift;
  my $replacement = shift;
  $replacement ||= "";
  
  $string =~ s/$regex/$replacement/g;

  return $string;
}

1;
