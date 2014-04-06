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

1;
