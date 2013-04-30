package Boxer::Graphic::Object::Base::Add;

use Moose;
use Boxer::Graphic::Widget::Box;

with 'Boxer::Graphic';
has 'outer_box' => ( isa => 'Boxer::Graphic::Widget::Box', is => 'rw' );

use constant ARGHEIGHT => 30;
use constant PADDING => 10;

sub BUILD {
    my ( $self ) = @_;
    $self->outer_box( Boxer::Graphic::Widget::Box->new() );
    $self->outer_box->fill( 1 );
}

sub get_geometry {
    my ( $self ) = @_;
    return ( ARGHEIGHT, ARGHEIGHT );
}

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my ( $x, $y ) = $self->get_position();

    my $outer_box = $self->outer_box();

    $outer_box->set_position( $x, $y );
    $outer_box->set_geometry( $self->geometry() );
    $outer_box->draw( $cr );

    $cr->restore();
}

1;
