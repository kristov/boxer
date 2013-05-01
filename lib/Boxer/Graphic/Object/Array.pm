package Boxer::Graphic::Object::Array;

use Moose;
use Boxer::Graphic::Widget::Box;

with 'Boxer::Graphic';

sub push {
    my ( $self, $item ) = @_;
    $self->{array} ||= [];
    push @{ $self->{array} }, $item;
}

sub pop {
}

sub get_geometry {
    my ( $self ) = @_;

    my $SIZEUNIT = $self->SIZEUNIT();
    my $PADDING  = $self->PADDING();

    my ( $x, $y ) = $self->get_position();
    my $array = $self->{array};

    my $nr_items  = scalar( @{ $array } );
    my $nr_spaces = 0;
    if ( $nr_items > 0 ) {
        $nr_spaces = $nr_items; # Would be -1, but add one for the handle
    }

    my $width = ( $nr_items * $SIZEUNIT ) + ( $nr_spaces * $PADDING );
    $width += $SIZEUNIT;

    my $height = $SIZEUNIT;

    return ( $width, $height );
}

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my $SIZEUNIT = $self->SIZEUNIT();
    my $PADDING  = $self->PADDING();

    my ( $x, $y ) = $self->get_position();
    my $array = $self->{array};

    my $nr_items = scalar( @{ $array } );

    my $box = Boxer::Graphic::Widget::Box->new();
    $box->fill( 1 );
    $box->set_position( $x, $y );
    $box->set_geometry( $SIZEUNIT, $SIZEUNIT );
    $box->color( [ 0.6, 0.6, 0.1 ] );
    $box->draw( $cr );

    $x += ( $SIZEUNIT + $PADDING );
    for my $thing ( 1 .. $nr_items ) {
        my $idx = $thing - 1;
        $box->set_position( $x, $y );
        $box->set_geometry( $SIZEUNIT, $SIZEUNIT );
        $box->color( [ 0.1, 0.6, 0.6 ] );
        $box->draw( $cr );
        $x += ( $SIZEUNIT + $PADDING );
    }

    $cr->restore();
}

1;
