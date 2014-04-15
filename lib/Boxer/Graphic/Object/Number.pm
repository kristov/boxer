package Boxer::Graphic::Object::Number;

use Moose;

with 'Boxer::Graphic';

sub BUILD {
    my ( $self ) = @_;
    $self->never_expanded( 1 );
    $self->color( [ 0.0, 0.6, 0.0 ] );
}

sub get_value {
    my ( $self ) = @_;
    return $self->GET_INDEX( 0 );
}

sub set_value {
    my ( $self, $value ) = @_;
    $self->text( $value );
    return $self->SET_INDEX( 0, $value );
}

1;
