package Boxer::Object::Number;

use Moose;

has 'value' => ( 'isa' => 'Int', 'is' => 'rw' );

1;
