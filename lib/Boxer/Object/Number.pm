package Boxer::Object::Number;

use Moose;
with 'Boxer::Object';

sub value { shift->PROPERTY( 'value', @_ ) }

1;
