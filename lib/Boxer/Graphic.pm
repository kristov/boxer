package Boxer::Graphic;

use Moose::Role;

has 'graphic_manager' => ( isa => 'Boxer::GraphicManager', is => 'rw' );
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

sub dispatch {
    my ( $self, $action, $parts ) = @_;
    if ( $self->can( $action ) ) {
        my $manager = $self->graphic_manager();
        my $gobject = $manager->graphic_object( $parts->[0]->[1] );
        $self->$action( $gobject );
    }
    else {
        my $selfref = "$self";
        print "Boxer::Graphic::dispatch() $self object can not $action\n";
    }
}

1;
