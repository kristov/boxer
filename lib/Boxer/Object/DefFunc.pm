package Boxer::Object::DefFunc;

use Moose;
with 'Boxer::Object::LIST';

sub set_args {
    my ( $self, $args ) = @_;
    $self->SET_INDEX( 0, $args );
}

sub set_body {
    my ( $self, $body ) = @_;
    return $self->SET_INDEX( 1, $body );
}

1;
