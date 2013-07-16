package Boxer::Graphic;

use Moose::Role;

has 'graphic_manager' => ( isa => 'Boxer::GraphicManager', is => 'rw' );
has 'x' => ( isa => 'Int', is => 'rw' );
has 'y' => ( isa => 'Int', is => 'rw' );
has 'highlighted' => ( isa => 'Int', is => 'rw', default => 0 );
has 'PADDING' => ( isa => 'Int', is => 'rw', default => 5 );
has 'SIZEUNIT' => ( isa => 'Int', is => 'rw', default => 20 );

sub get_position {
    my ( $self ) = @_;
    return ( $self->x(), $self->y() );
}

sub set_position {
    my ( $self, $x, $y ) = @_;
    $self->x( $x );
    $self->y( $y );
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

sub dispatch {
    my ( $self, $action, $parts ) = @_;
    if ( $self->can( $action ) ) {
        my $manager = $self->graphic_manager();
        my $gobject;
        if ( $parts->[0]->[0] =~ /CONSTANT$/ ) {
            $gobject = $parts->[0]->[1];
        }
        else {
            $gobject = $manager->graphic_object( $parts->[0]->[1] );
        }
        $self->$action( $gobject );
    }
    else {
        my $selfref = "$self";
        print "Boxer::Graphic::dispatch() $self object can not $action\n";
    }
}

1;
