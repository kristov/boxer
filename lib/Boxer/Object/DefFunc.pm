package Boxer::Object::DefFunc;

use Moose;

with 'Boxer::Object';

sub BUILD {
    my ( $self ) = @_;
    my $record = {};
    $self->data( $record );
}

no Moose;

1;
