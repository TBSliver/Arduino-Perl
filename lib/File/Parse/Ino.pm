package File::Parse::Ino;

use strict;
use warnings;

use File::Parse::Ino::Remove qw/ remove_all get_first_statement_index /;

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

  for (@function_matches, @prototype_matches) {
    $repeats{$_}++;
  }
  for (sort keys %repeats) {
    push(@diff, $_) unless $repeats{$_} > 1;
  }

  return \@diff;
}

1;
