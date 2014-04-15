package Boxer::Graphic::Object::CallFunc;

use Moose;

with 'Boxer::Graphic';

sub list_orientation {
    return [
        'horizontal',
        'horizontal',
    ];
}

sub set_calls {
    my ( $self, $calls ) = @_;
    $self->SET_INDEX( 0, $calls );
}

sub set_args {
    my ( $self, $args ) = @_;
    $self->SET_INDEX( 1, $args );
}

sub get_calls {
    my ( $self ) = @_;
    return $self->GET_INDEX( 0 );
}

sub get_args {
    my ( $self ) = @_;
    return $self->GET_INDEX( 1 );
}

sub BUILD {
    my ( $self ) = @_;
    $self->color( [ 0.6, 0.8, 0.4 ] );
    $self->orientation( 'horizontal' );
}

sub icon {
    return [
        {
            b => [ 0.1, 0.1, 0.4 ],
        },
        qq{
        ................
        .......b....bbb.
        ......b....b...b
        .....b.....b...b
        ....b......b....
        ...b.......b....
        ..b......bbbbbb.
        .b.........b....
        bbbbbbbb...b....
        .b.........b....
        ..b........b....
        ...b.......b....
        ....b...b..b....
        .....b...bb.....
        ......b.........
        .......b........
    } ];
}

1;
