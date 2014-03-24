package Boxer::Screen::Interface::WorkSpace;

use Moose;
use Boxer::Graphic::Widget::Box;

with 'Boxer::Screen::Interface';

has 'window' => (
    is  => 'rw',
    isa => 'Boxer::Screen::Interface::Window',
    documentation => "The window this heap interface is connected to",
);

has 'context' => (
    is  => 'rw',
    isa => 'Boxer::Graphic',
    documentation => "Thing being viewed",
);

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my $context = $self->context();

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

    if ( $context ) {
        $context->set_position( $x + $PADDING, $y + $PADDING );
        $context->draw( $cr );
    }

    $cr->restore();
}

1;
