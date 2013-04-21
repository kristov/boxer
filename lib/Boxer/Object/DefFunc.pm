package Boxer::Object::DefFunc;

use Moose;

with 'Boxer::Object';
has 'args' => ( isa => 'Boxer::Object::Array', is => 'rw' );
has 'body' => ( isa => 'Boxer::Object::Array', is => 'rw' );

sub set_args {
    my ( $self, $args ) = @_;
    $self->args( $args );
    $self->send_message( 'set_args', [ $args ] );
}

sub set_body {
    my ( $self, $body ) = @_;
    $self->body( $body );
    $self->send_message( 'set_body', [ $body ] );
}

1;
