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

has 'context' => (
    is  => 'rw',
    isa => 'Object',
    documentation => "What is selected in the interface element",
);

has 'highlighted' => (
    is  => 'rw',
    isa => 'Int',
    default => 0,
    documentation => "If set to 1, the element is highlighted in some way",
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

sub thing_to_highlight {
    my ( $self ) = @_;
    return $self;
}

sub highlight {
    my ( $self, $highlight ) = @_;
    my $thing = $self->thing_to_highlight();
    if ( defined $thing ) {
        $thing->highlighted( $highlight );
    }
    else {
        die "I dont have a thing_to_highlight!";
    }
}

sub dispatch_keypress {
    my ( $self, $key ) = @_;

    return if !$self->can( 'keys' );

    my $keys = $self->keys();
    if ( defined $keys->{$key} ) {
        $keys->{$key}->();
    }
}

1;
