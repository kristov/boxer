package Boxer::Graphic::Object::Type::Number;

use Moose;
with 'Boxer::Graphic';

use Boxer::Graphic::Widget::Box;

use constant HANDLEWID => 30;

sub geometry {
    my ( $self ) = @_;
    return ( HANDLEWID, HANDLEWID );
}

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my ( $x, $y ) = $self->get_position();

    my $box = Boxer::Graphic::Widget::Box->new();
    $box->fill( 1 );
    $box->set_position( $x, $y );
    $box->set_geometry( HANDLEWID, HANDLEWID );
    $box->color( [ 0.6, 0.6, 0.1 ] );
    $box->draw( $cr );

    $cr->restore();
}

1;
