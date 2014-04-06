package Boxer::Object::CallFunc;

use Moose;
with 'Boxer::Object::LIST';

sub set_calls {
    my ( $self, $calls ) = @_;
    $self->SET_INDEX( 0, $calls );
}

sub set_args {
    my ( $self, $args ) = @_;
    $self->SET_INDEX( 1, $args );
}

sub get_calls {
    my ( $self ) = @_;
    return $self->GET_INDEX( 0 );
}

sub get_args {
    my ( $self ) = @_;
    return $self->GET_INDEX( 1 );
}

1;
