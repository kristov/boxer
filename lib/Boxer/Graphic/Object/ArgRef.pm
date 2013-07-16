package Boxer::Graphic::Object::ArgRef;

use Moose;
with 'Boxer::Graphic';

use Boxer::Graphic::Widget::Box;

has 'outer_box' => ( isa => 'Boxer::Graphic::Widget::Box', is => 'rw' );
has 'array' => ( isa => 'Boxer::Object::Array', is => 'rw' );

use constant HANDLEWID => 30;

sub BUILD {
    my ( $self ) = @_;
    $self->outer_box( Boxer::Graphic::Widget::Box->new() );
    $self->outer_box->fill( 1 );
}

sub get_geometry {
    my ( $self ) = @_;
    my $SIZEUNIT = $self->SIZEUNIT();
    return ( $SIZEUNIT, $SIZEUNIT );
}

sub thing_to_highlight {
    my ( $self ) = @_;
    return $self->outer_box();
}

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my $SIZEUNIT = $self->SIZEUNIT();

    my ( $x, $y ) = $self->get_position();

    my $box = $self->outer_box();
    $box->set_position( $x, $y );
    $box->set_geometry( $SIZEUNIT, $SIZEUNIT );
    $box->color( [ 0.1, 0.6, 0.6 ] );
    $box->highlighted( $self->highlighted() );
    $box->draw( $cr );

    $cr->restore();
}

1;
