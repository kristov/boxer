package Boxer::Object::Namespace;

use Moose;
with 'Boxer::Object::LIST';

sub set_name {
    my ( $self, $name ) = @_;
    $self->SET_INDEX( 0, $name );
}

1;
