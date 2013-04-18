package Boxer::Object::DefFunc;

use Moose;

with 'Boxer::Object';
has 'arg_list' => ( isa => 'Boxer::Object::Array', is => 'rw' );
has 'body'     => ( isa => 'Boxer::Object::Array', is => 'rw' );

sub BUILD {
    my ( $self ) = @_;
    $self->arg_list(
}

1;
