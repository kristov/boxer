package Boxer::Graphic::Object::DefFunc;

use Moose;

with 'Boxer::Graphic';

sub list_orientation {
    return [
        'horizontal',
        'vertical',
    ];
}

sub set_args {
    my ( $self, $args ) = @_;
    $self->SET_INDEX( 0, $args );
}

sub set_body {
    my ( $self, $body ) = @_;
    $self->SET_INDEX( 1, $body );
}

sub get_args {
    my ( $self ) = @_;
    return $self->GET_INDEX( 0 );
}

sub get_body {
    my ( $self ) = @_;
    return $self->GET_INDEX( 1 );
}

sub next {
    my ( $self ) = @_;
    return $self->GET_INDEX( 1 );
}

sub BUILD {
    my ( $self ) = @_;
    $self->orientation( 'vertical' );
    $self->color( [ 0.0, 0.0, 0.4 ] );
}

sub icon {
    return [
        {
            b => [ 1, 1, 1 ],
        },
        qq{
        ................
        ........bbb.....
        .......b...b....
        .......b...b....
        .......b........
        .......b........
        .....bbbbbb.....
        .......b........
        .......b........
        .......b........
        .......b........
        .......b........
        ....b..b........
        .....bb.........
        ................
        ................
    } ];
}

1;
