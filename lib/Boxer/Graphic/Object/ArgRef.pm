package Boxer::Graphic::Object::ArgRef;

use Moose;
with 'Boxer::Graphic';

use Boxer::Graphic::Widget::Box;

has 'array' => ( isa => 'Boxer::Object::Array', is => 'rw' );

use constant HANDLEWID => 30;

sub get_geometry {
    my ( $self ) = @_;
    my $SIZEUNIT = $self->SIZEUNIT();
    return ( $SIZEUNIT, $SIZEUNIT );
}

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my $SIZEUNIT = $self->SIZEUNIT();

    my ( $x, $y ) = $self->get_position();

    my $box = Boxer::Graphic::Widget::Box->new();
    $box->fill( 1 );
    $box->set_position( $x, $y );
    $box->set_geometry( $SIZEUNIT, $SIZEUNIT );
    $box->color( [ 0.1, 0.6, 0.6 ] );
    $box->draw( $cr );

    $cr->restore();
}

1;
