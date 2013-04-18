package Boxer::Graphic::Object::Array;

use Moose;
use Boxer::Graphic::Widget::Box;

with 'Boxer::Graphic';
has 'array' => ( isa => 'Boxer::Object::Array', is => 'rw' );

use constant HANDLEWID => 30;
use constant ARGHEIGHT => 30;
use constant ARGWIDTH  => 30;
use constant ARGSPACES => 10;

sub geometry {
    my ( $self ) = @_;

    my ( $x, $y ) = $self->get_position();
    my $array = $self->array();
    my $data = $array->data();
    $data ||= [];

    my $nr_items  = scalar( @{ $data } );
    my $nr_spaces = 0;
    if ( $nr_items > 0 ) {
        $nr_spaces = $nr_items; # Would be -1, but add one for the handle
    }

    my $width = ( $nr_items * ARGWIDTH ) + ( $nr_spaces * ARGSPACES );
    $width += HANDLEWID;

    my $height = ARGHEIGHT;

    return ( $width, $height );
}

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my ( $x, $y ) = $self->get_position();
    my $array = $self->array();
    my $data = $array->data();
    $data ||= [];

    my $nr_items = scalar( @{ $data } );

    my $box = Boxer::Graphic::Widget::Box->new();
    $box->fill( 1 );
    $box->set_position( $x, $y );
    $box->set_geometry( HANDLEWID, HANDLEWID );
    $box->color( [ 0.6, 0.6, 0.1 ] );
    $box->draw( $cr );

    $x += ( HANDLEWID + ARGSPACES );
    for my $thing ( 1 .. $nr_items ) {
        my $idx = $thing - 1;
        $box->set_position( $x, $y );
        $box->set_geometry( ARGWIDTH, ARGHEIGHT );
        $box->color( [ 0.1, 0.6, 0.6 ] );
        $box->draw( $cr );
        $x += ( ARGWIDTH + ARGSPACES );
    }

    $cr->restore();
}

1;
