package Boxer::Object::RefFunc;

use Moose;
with 'Boxer::Object';

sub refs { shift->PROPERTY( 'refs', @_ ) }

1;
