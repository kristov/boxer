package Boxer::Object::CallFunc;

use Moose;

with 'Boxer::Object';
has 'calls' => ( isa => 'Ref', is => 'rw' );
has 'args'  => ( isa => 'Boxer::Object::Array', is => 'rw' );

1;
