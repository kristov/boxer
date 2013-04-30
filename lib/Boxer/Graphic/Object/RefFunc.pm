package Boxer::Graphic::Object::RefFunc;

use Moose;
use Boxer::Graphic::Widget::Box;

with 'Boxer::Graphic';
has 'outer_box' => ( isa => 'Boxer::Graphic::Widget::Box', is => 'rw' );
has 'refs'      => ( isa => 'Ref', is => 'rw' );

use constant PADDING => 10;

sub BUILD {
    my ( $self ) = @_;
    $self->outer_box( Boxer::Graphic::Widget::Box->new() );
    $self->outer_box->fill( 1 );
}

sub get_geometry {
    my ( $self ) = @_;

    my $refs = $self->refs();
    my ( $width, $height );

    if ( $refs ) {
        ( $width, $height ) = $refs->geometry();
    }
    else {
        ( $width, $height ) = ( 30, 30 );
    }
    return ( $width, $height );
}

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my ( $x, $y ) = $self->get_position();

    my $outer_box = $self->outer_box();

    $outer_box->set_position( $x, $y );
    $outer_box->set_geometry( $self->get_geometry() );
    $outer_box->draw( $cr );

    $cr->restore();
}

1;
