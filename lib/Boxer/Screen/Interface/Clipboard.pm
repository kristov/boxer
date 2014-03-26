package Boxer::Screen::Interface::Clipboard;

use Moose;
use Boxer::Graphic::Widget::Box;

with 'Boxer::Screen::Interface';

has 'window' => (
    is  => 'rw',
    isa => 'Boxer::Screen::Interface::Window',
    documentation => "The window this heap interface is connected to",
);

has 'clipboard' => (
    is  => 'rw',
    isa => 'Object',
    documentation => "The thing in the clipboard",
);

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my $clipboard = $self->clipboard();

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

    if ( $clipboard ) {
        $clipboard->set_position( $x + $PADDING, $y + $PADDING );
        $clipboard->draw( $cr );
    }

    $cr->restore();
}

1;
