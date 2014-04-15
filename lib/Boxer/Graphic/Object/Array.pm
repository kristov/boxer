package Boxer::Graphic::Object::Array;

use Moose;

with 'Boxer::Graphic';

sub next {
    my ( $self ) = @_;
    return $self->LIST->[0];
}

sub icon {
    return [
        {
            b => [ 0.1, 0.1, 0.4 ],
        },
        qq{
        ..bbbbbbbbbbbb..
        .b............b.
        b..bbbbbbbbbb..b
        b.b..........b.b
        b.b..bbbbbb..b.b
        b.b.b......b.b.b
        b.b.b..bb..b.b.b
        b.b.b.b.b..b.b.b
        b.b.b.b....b.b.b
        b.b.b..bbbb..b.b
        b.b.b........b.b
        b.b..bbbbbbbb..b
        b.b............b
        b..bbbbbbbbbbbb.
        .b..............
        ..bbbbbbbbbbbbb.
    } ];
}

1;
