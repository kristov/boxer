package Boxer::RunTime;

use Moose;
use Boxer::Object::Heap;

has 'screen' => ( isa => 'Ref', is => 'rw' );
has 'heap' => ( isa => 'Boxer::Object::Heap', is => 'rw' );
has 'main' => ( isa => 'Boxer::Object::DefFunc', is => 'rw' );

sub initialize {
    my ( $self ) = @_;
    my $heap = Boxer::Object::Heap->new( $self );
    $self->heap( $heap );
}

sub new_object {
    my ( $self, $object ) = @_;
    if ( my $heap = $self->heap() ) {
        $heap->PUSH( $object );
    }
    else {
        # this should only happen from the initialize sub above when the
        # heap is created, because the heap can not be added to the heap
    }
}

sub send_message {
    my ( $self, $message ) = @_;

    $message =~ s/^\|//;
    $message =~ s/\|$//;
    my ( $objref, $action, $data ) = split( /\|/, $message );

    my ( $mainclass, $mainid ) = parse_identifier( $objref );

    my @datas;
    if ( $data ) {
        my @parts = split( /,/, $data );
        for my $part ( @parts ) {
            my ( $partclass, $partid ) = parse_identifier( $part );
            push @datas, [ $partclass, $partid ];
        }
    }

    if ( my $screen = $self->screen() ) {
        $screen->send_message( [ $mainclass, $mainid ], $action, \@datas );
    }
}

sub parse_identifier {
    my ( $ident ) = @_;
    my ( $class, $id );
    if ( $ident =~ /([A-Za-z0-9:]+)=HASH\(([0-9a-z]+)\)/ ) {
        ( $class, $id ) = ( $1, $2 );
    }
    return ( $class, $id );
}

sub iteration {
    my ( $self ) = @_;
    $self->step_forward();
}

sub step_forward {
    my ( $self ) = @_;
}

1;
