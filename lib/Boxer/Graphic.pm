package Boxer::Graphic;

use Moose::Role;

has 'object' => ( isa => 'Ref', is => 'rw' );
has 'x'      => ( isa => 'Int', is => 'rw' );
has 'y'      => ( isa => 'Int', is => 'rw' );

sub get_position {
    my ( $self ) = @_;
    return ( $self->x(), $self->y() );
}

sub set_position {
    my ( $self, $x, $y ) = @_;
    $self->x( $x );
    $self->y( $y );
}

no Moose::Role;

1;
