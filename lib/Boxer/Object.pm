package Boxer::Object;

use Moose::Role;

has 'data' => ( isa => 'Ref', is => 'rw' );
has 'graphic' => ( isa => 'Ref', is => 'rw' );

sub send_message {
    my ( $self, $name, $data ) = @_;
    # TODO: send the message...
}

1;
