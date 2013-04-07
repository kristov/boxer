package Boxer::Object;

use Moose::Role;

has 'data' => ( isa => 'Ref', is => 'rw' );
has 'graphic' => ( isa => 'Ref', is => 'rw' );

no Moose::Role;

1;
