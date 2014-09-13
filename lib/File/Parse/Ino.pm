package File::Parse::Ino;

use strict;
use warnings;

use File::Parse::Ino::Remove qw/ remove_all /;
use File::Parse::Ino::Get qw/ :all /;

use IO::All;
use Moo;
use namespace::clean;

has program => (
  is => 'ro',
  required => 1
);

has path => (
  is => 'ro',
  required => 1
);

has output => (
  is => 'lazy'
);

has prefix => (
  is => 'ro',
  default => "#include \"Arduino.h\"\n"
);

sub _build_output {
  my $self = shift;

  my $output = $self->prefix;

  my $first_statement_index = get_first_statement_index( $self->program );

  my $prototype_insert = join(";\n", @{$self->_get_prototypes}) . ";\n";

  $output .= substr( $self->program, 0, $first_statement_index );
  $output .= $prototype_insert;
  $output .= substr( $self->program, $first_statement_index );

  # if there is no newline at the end, add one
  if (substr($self->program, -1, 1) ne "\n") {
    $output .= "\n";
  }

  return $output;
}

sub write {
  my $self = shift;

  my $fh = io($self->path);
  $fh->print($self->output);

  return $fh->name;
}

sub _get_prototypes {
  my $self = shift;

  my $stripped_program = $self->program;

  $stripped_program = remove_all($stripped_program);

  # These patterns are taken straight from the Arduino Distribution
  my $prototype_pattern
    = "[\\w\\[\\]\\*]+\\s+[&\\[\\]\\*\\w\\s]+\\([&,\\[\\]\\*\\w\\s]*\\)(?=\\s*;)";
  my $function_pattern
    = "[\\w\\[\\]\\*]+\\s+[&\\[\\]\\*\\w\\s]+\\([&,\\[\\]\\*\\w\\s]*\\)(?=\\s*\\{)";

  my @function_matches = $stripped_program =~ m/$function_pattern/g;
  my @prototype_matches = $stripped_program =~ m/$prototype_pattern/g;

  my @diff;
  my %repeats;

  #set a 'flag' for each function
  for (@function_matches) {
    $repeats{$_} = 1;
  }
  # if a prototype for this exists, then increment the flag
  for (@prototype_matches) {
    $repeats{$_}++ if exists $repeats{$_};
  }
  # only remember functions which have no prototype set yet
  for (sort keys %repeats) {
    push(@diff, $_) unless $repeats{$_} > 1;
  }

  return \@diff;
}

1;
