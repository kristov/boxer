package Boxer::Object::DefFunc;

use Moose;
with 'Boxer::Object';

sub args { shift->PROPERTY( 'args', @_ ) }
sub body { shift->PROPERTY( 'body', @_ ) }

1;
