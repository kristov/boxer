package Boxer::Graphic::Object::Number;

use Moose;
with 'Boxer::Graphic';
has 'box' => ( 'isa' => 'Boxer::Graphic::Widget::Box', 'is' => 'rw' );

use Boxer::Graphic::Widget::Box;

use constant HANDLEWID => 30;

sub BUILD {
    my ( $self ) = @_;
    $self->box( Boxer::Graphic::Widget::Box->new() );
    $self->box->fill( 1 );
    $self->box->set_geometry( HANDLEWID, HANDLEWID );
    $self->box->color( [ 0.6, 0.6, 0.1 ] );
}

sub geometry {
    my ( $self ) = @_;
    return ( HANDLEWID, HANDLEWID );
}

sub draw {
    my ( $self, $cr ) = @_;
    $cr->save();

    my ( $x, $y ) = $self->get_position();

    my $box = $self->box();
    $box->set_position( $x, $y );
    $box->draw( $cr );

    $cr->restore();
}

1;
