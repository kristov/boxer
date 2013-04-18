package Boxer::Graphic::Object::RefFunc;

use Moose;
use Boxer::Graphic::Widget::Box;

with 'Boxer::Graphic';
has 'outer_box' => ( isa => 'Boxer::Graphic::Widget::Box', is => 'rw' );
has 'reffunc'   => ( isa => 'Boxer::Object::RefFunc', is => 'rw' );
has 'arglist'   => ( isa => 'Boxer::Graphic::Object::Array', is => 'rw' );

use constant PADDING => 10;

sub BUILD {
    my ( $self ) = @_;
    $self->outer_box( Boxer::Graphic::Widget::Box->new() );
    $self->outer_box->fill( 1 );
}

sub geometry {
    my ( $self ) = @_;
    my ( $width, $height ) = $self->arglist->geometry();
    return ( $width + ( PADDING * 2 ), $height + ( PADDING * 2 ) );
}

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my ( $x, $y ) = $self->get_position();

    my $outer_box = $self->outer_box();

    $outer_box->set_position( $x, $y );
    $outer_box->set_geometry( $self->geometry() );
    $outer_box->draw( $cr );

    my $arglist = $self->arglist();
    $arglist->set_position( $x + PADDING, $y + PADDING );
    $arglist->draw( $cr );

    $cr->restore();
}

sub get_geometry {
    my ( $self ) = @_;
    return $self->geometry();
}

no Moose;

1;
