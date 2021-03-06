package Boxer::Object::DefFunc;

use Moose;
with 'Boxer::Object::LIST';

sub set_args {
    my ( $self, $args ) = @_;
    $self->SET_INDEX( 0, $args );
}

sub set_body {
    my ( $self, $body ) = @_;
    $self->SET_INDEX( 1, $body );
}

sub get_args {
    my ( $self, $args ) = @_;
    return $self->GET_INDEX( 0 );
}

sub get_body {
    my ( $self ) = @_;
    return $self->GET_INDEX( 1 );
}

1;
