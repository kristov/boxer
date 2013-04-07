package Boxer::Object::CallFunc;

use Moose;

with 'Boxer::Object';
has 'reffunc' => ( isa => 'Boxer::Object::RefFunc', is => 'rw' );

sub BUILD {
    my ( $self ) = @_;
    my $record = {};
    $self->data( $record );
}

no Moose;

1;
