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

sub keys {
    my ( $self ) = @_;
    return {
        up    => sub { $self->descend() },
        down  => sub { $self->ascend() },
        left  => sub { $self->backout() },
        right => sub { $self->gointo() },
    };
}

sub descend {
    my ( $self ) = @_;
    my $context = $self->context();
    if ( $context ) {
    }
}

sub ascend {
    my ( $self ) = @_;
    my $context = $self->context();
    if ( $context ) {
    }
}

sub backout {
    my ( $self ) = @_;
    my $context = $self->context();
    if ( $context ) {
    }
}

sub gointo {
    my ( $self ) = @_;
    my $context = $self->context();
    if ( $context ) {
    }
}

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my $context = $self->context();

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

    if ( $context ) {
        $context->set_position( $x + $PADDING, $y + $PADDING );
        $context->draw( $cr );
    }

    $cr->restore();
}

1;
