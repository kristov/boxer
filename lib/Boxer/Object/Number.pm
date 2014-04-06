package Boxer::Object::Number;

use Moose;
with 'Boxer::Object::LIST';

sub set_value {
    my ( $self, $args ) = @_;
    $self->SET_INDEX( 0, $args );
}

sub get_value {
    my ( $self ) = @_;
    $self->GET_INDEX( 0 );
}

1;
