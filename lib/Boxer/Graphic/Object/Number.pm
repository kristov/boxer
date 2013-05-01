package Boxer::Graphic::Object::Number;

use Moose;
with 'Boxer::Graphic';
has 'box' => ( 'isa' => 'Boxer::Graphic::Widget::Box', 'is' => 'rw' );

use Boxer::Graphic::Widget::Box;

sub BUILD {
    my ( $self ) = @_;
    $self->box( Boxer::Graphic::Widget::Box->new() );
    $self->box->fill( 1 );
    $self->box->color( [ 0.6, 0.6, 0.1 ] );
}

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

    my $box = $self->box();
    $box->set_position( $x, $y );
    $self->box->set_geometry( $SIZEUNIT, $SIZEUNIT );
    $box->draw( $cr );

    $cr->restore();
}

1;
