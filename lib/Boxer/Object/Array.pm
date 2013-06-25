package Boxer::Object::Array;

use Moose;
with 'Boxer::Object';

sub boxer_init {
    my ( $self ) = @_;
    $self->{array} = [];
}

sub array { shift->PROPERTY( 'array', @_ ) }

sub push {
    my ( $self, $item ) = @_;
    my $record = $self->array();
    push @{ $record }, $item;
    $self->send_message( 'push', [ $item ] );
}

1;
