package Boxer::Object::Array;

use Moose;

with 'Boxer::Object';

sub BUILD {
    my ( $self ) = @_;
    my $record = [];
    $self->data( $record );
}

sub push {
    my ( $self, $item ) = @_;
    my $record = $self->data();
    push @{ $record }, $item;
    $self->send_message( 'push', [ $item ] );
}

1;
