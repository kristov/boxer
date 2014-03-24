package Boxer::Screen::Interface::Heap;

use Moose;
use Boxer::Graphic::Widget::Box;

with 'Boxer::Screen::Interface';

has 'window' => (
    is  => 'rw',
    isa => 'Boxer::Screen::Interface::Window',
    documentation => "The window this heap interface is connected to",
);

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my $heap = $self->window->screen->heap();

    my $SIZEUNIT = $self->SIZEUNIT();
    my $PADDING = $self->PADDING();

    my ( $x, $y ) = $self->get_position();
    my ( $width, $height ) = $self->get_geometry();

    my $box = Boxer::Graphic::Widget::Box->new();
    $box->fill( 1 );
    $box->set_position( $x, $y );
    $box->set_geometry( $width, $height );
    $box->color( [ 0.3, 0.3, 0.3 ] );
    $box->draw( $cr );

    $heap->set_position( $x + $PADDING, $y + $PADDING );
    $heap->draw( $cr );

    $cr->restore();
}

1;
