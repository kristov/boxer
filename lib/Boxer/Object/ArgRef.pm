package Boxer::Object::ArgRef;

use Moose;

has 'refs' => ( 'isa' => 'Ref', 'is' => 'rw' );

1;
