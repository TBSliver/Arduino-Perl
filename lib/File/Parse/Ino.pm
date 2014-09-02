package File::Parse::Ino;

use strict;
use warnings;

use IO::All;
use C::Tokenize qw/ $comment_re
                    $cpp_re /;

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

has _io_output => (
  is => 'lazy'
);

sub build__io_output {
  my $self = shift;

  my $file = io( $self->path );
  
  return $file;
}

sub write {
  my $self = shift;

  

  return $self->_io_output->name;
}

sub _remove_comments {
  my $self = shift;
  my $string = shift;

  $string =~ s/$comment_re//g;

  return $string;
}

sub _remove_preprocessors {
  my $self = shift;
  my $string = shift;

  $string =~ s/$cpp_re//g;

  return $string;
}

sub _get_prototypes {
  my $self = shift;



}

1;
