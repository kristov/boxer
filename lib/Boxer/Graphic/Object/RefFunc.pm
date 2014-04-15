package Boxer::Graphic::Object::RefFunc;

use Moose;

with 'Boxer::Graphic';

sub BUILD {
    my ( $self ) = @_;
    $self->never_expanded( 1 );
}

sub get_refs {
    my ( $self ) = @_;
    return $self->GET_INDEX( 0 );
}

sub next {
    my ( $self ) = @_;
    return $self->GET_INDEX( 0 );
}

sub icon {
    return [
        {
            b => [ 0.3, 0.9, 0.4 ],
        },
        qq{
        ................
        ...bb......bb...
        ...bb......bb...
        ...bb......bb...
        .bbbbbbbbbbbbbb.
        .bbbbbbbbbbbbbb.
        ...bb......bb...
        ...bb......bb...
        ...bb......bb...
        ...bb......bb...
        .bbbbbbbbbbbbbb.
        .bbbbbbbbbbbbbb.
        ...bb......bb...
        ...bb......bb...
        ...bb......bb...
        ................
    } ];
}

1;
