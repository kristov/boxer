package Boxer::Screen::Interface;

use Moose::Role;

has 'x' => (
    is  => 'rw',
    isa => 'Int',
    documentation => "The x position of this element within its parent",
);

has 'y' => (
    is  => 'rw',
    isa => 'Int',
    documentation => "The y position of this element within its parent",
);

has 'w' => (
    is  => 'rw',
    isa => 'Int',
    documentation => "The width of the element",
);

has 'h' => (
    is  => 'rw',
    isa => 'Int',
    documentation => "The height of the element",
);

has 'PADDING' => (
    is  => 'rw',
    isa => 'Int',
    default => 5,
    documentation => "How much padding should be used for child elements",
);

has 'SIZEUNIT' => (
    is  => 'rw',
    isa => 'Int',
    default => 20,
    documentation => "How large should the element be rendered",
);

sub get_position {
    my ( $self ) = @_;
    return ( $self->x(), $self->y() );
}

sub set_position {
    my ( $self, $x, $y ) = @_;
    $self->x( $x );
    $self->y( $y );
}

sub set_geometry {
    my ( $self, $w, $h ) = @_;
    $self->w( $w );
    $self->h( $h );
}

sub get_geometry {
    my ( $self ) = @_;
    return ( $self->w, $self->h );
}

1;
