package Boxer::Object::RefFunc;

use Moose;

with 'Boxer::Object';
has 'name' => ( isa => 'Str', is => 'rw' );
has 'refs' => ( isa => 'Boxer::Object::DefFunc', is => 'rw' );

1;
