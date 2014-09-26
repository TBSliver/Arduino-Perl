package File::Parse::Ino::Get;

use strict;
use warnings;

use Exporter qw/ import /;

our @EXPORT_OK = qw/
get_first_statement_index
get_include_targets
/;

our %EXPORT_TAGS = ( all => \@EXPORT_OK );

use C::Tokenize qw/ $trad_comment_re
                    $comment_re
                    $cpp_re /;

use Regexp::Common qw/ balanced /;

sub get_first_statement_index {
  my $string = shift;

  my $regex = $comment_re . "|" . $cpp_re . "|" . "\\s+";

  $string =~ m/($regex)*/g;

  # @+ special variable is the last index of the match
  my $index = $+[0];

  return $index;
}

sub get_include_targets {
  my $string = shift;
  
  $string =~ s/$trad_comment_re//g;

  my @all_preprocessors = $string =~ m/$cpp_re/g;

  my @import_statements = grep(/include/, @all_preprocessors);

  my @final_output;

  for my $input (@import_statements) {

    $input =~ s/#include\s+($RE{balanced}{-begin=>"\"|<"}{-end=>"\"|>"}).*/$1/;
    $input =~ s/\"|<|>//g;

    chomp $input;

    push @final_output, $input;

  }

  return \@final_output;

}
