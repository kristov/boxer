package Boxer::Object::RefFunc;

use Moose;

with 'Boxer::Object';
has 'name' => ( isa => 'Str', is => 'rw' );
has 'func' => ( isa => 'Boxer::Object::DefFunc', is => 'rw' );

sub BUILD {
    my ( $self ) = @_;
    my $record = {};
    $self->data( $record );
}

no Moose;

1;
