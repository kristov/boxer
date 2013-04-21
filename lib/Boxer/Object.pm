package Boxer::Object;

use Moose::Role;

has 'data'    => ( isa => 'Ref', is => 'rw' );
has 'graphic' => ( isa => 'Ref', is => 'rw' );

sub BUILD {
    my ( $self ) = @_;
    $self->send_message( 'new', $self );
}

sub send_message {
    my ( $self, $name, $data ) = @_;
    my $ref = ref( $self );
    my $message = sprintf( '|%10s|%s|', $name, $ref );
    warn "$message\n";
    # TODO: send the message...
}

1;
