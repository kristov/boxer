package Boxer::Screen::Interface::Heap;

use Moose;
use Boxer::Graphic::Widget::Box;

with 'Boxer::Screen::Interface';
with 'Boxer::Screen::Interface::ListLike';

has 'window' => (
    is  => 'rw',
    isa => 'Boxer::Screen::Interface::Window',
    documentation => "The window this heap interface is connected to",
);

sub hooks {
    my ( $self ) = @_;
    return {
        unselected => sub { $self->heap->highlight_element( $_[0], 0 ) },
        selected   => sub { $self->heap->highlight_element( $_[0], 1 ) },
        enter      => sub { $self->heap->enter_on_item( $_[0] ) },
    };
}

sub heap {
    my ( $self ) = @_;
    return $self->window->screen->heap();
}

sub length {
    my ( $self ) = @_;
    return $self->heap->length();
}

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my $heap = $self->window->screen->heap();

    my $SIZEUNIT = $self->SIZEUNIT();
    my $PADDING = $self->PADDING();

    my ( $x, $y ) = $self->get_position();
    my ( $width, $height ) = $self->get_geometry();

    my $color = $self->highlighted
        ? [ 0.5, 0.5, 0.5 ]
        : [ 0.3, 0.3, 0.3 ];

    my $box = Boxer::Graphic::Widget::Box->new();
    $box->fill( 1 );
    $box->set_position( $x, $y );
    $box->set_geometry( $width, $height );
    $box->color( $color );
    $box->draw( $cr );

    $heap->set_position( $x + $PADDING, $y + $PADDING );
    $heap->draw( $cr );

    $cr->restore();
}

1;
