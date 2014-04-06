package Boxer::Object::ArgRef;

use Moose;
with 'Boxer::Object::LIST';

sub set_refs {
    my ( $self, $refs ) = @_;
    $self->SET_INDEX( 0, $refs );
}

1;
