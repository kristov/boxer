package Boxer::Graphic::Object::Heap;

use Moose;
use Boxer::Graphic::Widget::Box;

with 'Boxer::Graphic';

sub get_geometry {
    my ( $self ) = @_;

    my $SIZEUNIT = $self->SIZEUNIT();
    my $PADDING = $self->PADDING();

    my ( $x, $y ) = $self->get_position();
    my $array = $self->LIST();

    my $nr_items  = scalar( @{ $array } );
    my $nr_spaces = 0;
    if ( $nr_items > 0 ) {
        $nr_spaces = $nr_items + 1;
    }

    my $height = 0;
    my $max_width = $SIZEUNIT;
    for my $item ( @{ $array } ) {
        my $expanded = $item->expanded();
        $item->expanded( 0 );
        my ( $iwidth, $iheight ) = $item->get_geometry();
        $item->expanded( $expanded );
        $height += $iheight;
        $max_width = $iwidth if $iwidth > $max_width;
    }
    $height += ( $nr_spaces * $PADDING );
    $height ||= $SIZEUNIT;

    return ( $SIZEUNIT + ( $PADDING * 2 ), $height );

    return ( $max_width + ( $PADDING * 2 ), $height );
}

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my $SIZEUNIT = $self->SIZEUNIT();
    my $PADDING = $self->PADDING();

    my ( $x, $y ) = $self->get_position();
    my $array = $self->LIST();

    my $nr_items = scalar( @{ $array } );

    my ( $width, $height ) = $self->get_geometry();

    my $box = Boxer::Graphic::Widget::Box->new();
    $box->fill( 1 );
    $box->set_position( $x, $y );
    $box->set_geometry( $width, $height );
    $box->color( [ 0.2, 0.2, 0.2 ] );
    $box->draw( $cr );

    $x += $PADDING;
    $y += $PADDING;

    for my $item ( @{ $array } ) {
        my $expanded = $item->expanded();
        $item->expanded( 0 );
        $item->set_position( $x, $y );
        my ( $iwidth, $iheight ) = $item->get_geometry();
        $item->draw( $cr );
        $item->expanded( $expanded );
        $y += ( $iheight + $PADDING );
    }

    $cr->restore();
}

1;
