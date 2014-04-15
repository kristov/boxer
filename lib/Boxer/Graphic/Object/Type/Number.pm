package Boxer::Graphic::Object::Type::Number;

use Moose;

with 'Boxer::Graphic';

sub BUILD {
    my ( $self ) = @_;
    $self->text( "x" );
    $self->never_expanded( 1 );
    $self->color( [ 0.0, 0.6, 0.0 ] );
}

1;
