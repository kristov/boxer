package Boxer::Graphic::Object::Base::Add;

use Moose;
use Boxer::Graphic::Widget::Box;

with 'Boxer::Graphic';
has 'outer_box' => ( isa => 'Boxer::Graphic::Widget::Box', is => 'rw' );

sub BUILD {
    my ( $self ) = @_;
    $self->outer_box( Boxer::Graphic::Widget::Box->new() );
    $self->outer_box->fill( 1 );
}

sub icon {
    return [
        {
            b => [ 0.3, 0.9, 0.4 ],
        },
        qq{
        .......bb.......
        .......bb.......
        .......bb.......
        .......bb.......
        .......bb.......
        .......bb.......
        .......bb.......
        bbbbbbbbbbbbbbbb
        bbbbbbbbbbbbbbbb
        .......bb.......
        .......bb.......
        .......bb.......
        .......bb.......
        .......bb.......
        .......bb.......
        .......bb.......
    } ];
}

sub thing_to_highlight {
    my ( $self ) = @_;
    return $self->outer_box();
}

sub get_geometry {
    my ( $self ) = @_;
    my $SIZEUNIT = $self->SIZEUNIT();
    return ( $SIZEUNIT, $SIZEUNIT );
}

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my ( $x, $y ) = $self->get_position();
    my $outer_box = $self->outer_box();

    $outer_box->set_position( $x, $y );
    $outer_box->set_geometry( $self->get_geometry() );
    $outer_box->draw( $cr );
    $self->draw_icon( $cr, $x, $y );

    $cr->restore();
}

1;
