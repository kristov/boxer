package Boxer::Screen::Interface::Message;

use Moose;
use Boxer::Graphic::Widget::Box;

with 'Boxer::Screen::Interface';

has 'window' => (
    is  => 'rw',
    isa => 'Boxer::Screen::Interface::Window',
    documentation => "The window this message box interface is connected to",
);

has 'text' => (
    is  => 'rw',
    isa => 'Str',
    documentation => "The message to display",
);

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

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

    if ( $self->text ) {
        $cr->set_source_rgb( 0.6, 0.6, 0.6 );
        $cr->select_font_face( "Sans", 'normal', 'normal' );
        $cr->set_font_size( 17.0 );
        $cr->move_to( $x + $PADDING, $y + $SIZEUNIT );
        $cr->show_text( $self->text );
    }

    $cr->restore();
}

1;
