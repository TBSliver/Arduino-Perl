package File::Parse::Ino;

use strict;
use warnings;

use File::Parse::Ino::Remove qw/ :all /;

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

sub _get_prototypes {
  my $self = shift;

}

1;
