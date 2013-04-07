package Boxer::Graphic::Object::CallFunc;

use Moose;
use Boxer::Graphic::Widget::Box;

with 'Boxer::Graphic';
has 'outer_box' => ( isa => 'Boxer::Graphic::Widget::Box', is => 'rw' );

use constant PADDING => 10;

sub BUILD {
    my ( $self ) = @_;
    $self->outer_box( Boxer::Graphic::Widget::Box->new() );
    $self->outer_box->color( [ 0.6, 0.8, 0.4 ] );
    $self->outer_box->fill( 1 );
}

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my ( $x, $y ) = $self->get_position();
    my ( $width, $height );

    my $greffunc;

    my $callfunc = $self->object();
    if ( $callfunc ) {
        my $reffunc = $callfunc->reffunc();
        if ( $reffunc ) {
            $greffunc = $reffunc->graphic();
            ( $width, $height ) = $greffunc->get_geometry();
        }
    }
    else {
        ( $width, $height ) = ( 400, 60 );
    }

    my $outer_box = $self->outer_box();
    $outer_box->set_position( $x, $y );
    $outer_box->set_geometry( $width + ( PADDING * 2 ), $height + ( PADDING * 2 ) );
    $outer_box->draw( $cr );

    $greffunc->set_position( $x + PADDING, $y + PADDING );
    $greffunc->draw( $cr ) if $greffunc;

    $cr->restore();
}

no Moose;

1;
