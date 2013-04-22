package Boxer::Object::CallFunc;

use Moose;
with 'Boxer::Object';

sub calls { shift->PROPERTY( 'calls', @_ ) }
sub args { shift->PROPERTY( 'args', @_ ) }

1;
