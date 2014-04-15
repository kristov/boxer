package Boxer::Graphic::Object::ArgRef;

use Moose;

with 'Boxer::Graphic';

sub BUILD {
    my ( $self ) = @_;
    $self->never_expanded( 1 );
    $self->color( [ 0.1, 0.6, 0.6 ] );
}

1;
