package Boxer::Graphic::Object::Type::Number;

use Moose;
use Boxer::Graphic::Widget::Box;

with 'Boxer::Graphic';
has 'outer_box' => ( isa => 'Boxer::Graphic::Widget::Box', is => 'rw' );

sub BUILD {
    my ( $self ) = @_;
    $self->outer_box( Boxer::Graphic::Widget::Box->new() );
    $self->outer_box->fill( 1 );
    $self->outer_box->color( [ 0.6, 0.6, 0.1 ] );
}

sub thing_to_highlight {
    my ( $self ) = @_;
    return $self->outer_box();
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

    my $outer_box = $self->outer_box();
    $outer_box->set_position( $x, $y );
    $outer_box->set_geometry( $SIZEUNIT, $SIZEUNIT );
    $outer_box->draw( $cr );

    $cr->restore();
}

1;
