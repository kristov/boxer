package Boxer::Graphic::Object::CallFunc;

use Moose;
use Boxer::Graphic::Widget::Box;

with 'Boxer::Graphic';

has 'outer_box' => (
    is  => 'rw',
    isa => 'Boxer::Graphic::Widget::Box',
);

sub next {
    my ( $self ) = @_;
    return $self->{calls};
}

sub calls {
    my ( $self, $gobject ) = @_;
    if ( defined $gobject ) {
        $self->{calls} = $gobject;
        $gobject->parent( $self );
    }
    return $self->{calls};
}

sub args {
    my ( $self, $gobject ) = @_;
    if ( defined $gobject ) {
        $self->{args} = $gobject;
        $gobject->parent( $self );
    }
    return $self->{args};
}

sub BUILD {
    my ( $self ) = @_;
    $self->outer_box( Boxer::Graphic::Widget::Box->new() );
    $self->outer_box->color( [ 0.6, 0.8, 0.4 ] );
    $self->outer_box->fill( 1 );
}

sub thing_to_highlight {
    my ( $self ) = @_;
    return $self->outer_box();
}

sub get_geometry {
    my ( $self ) = @_;

    my $SIZEUNIT = $self->SIZEUNIT();
    my $PADDING  = $self->PADDING();

    my ( $width, $height );
    my ( $argw, $argh );

    my $greffunc = $self->calls();
    my $gargs    = $self->args();

    if ( $greffunc ) {
        ( $width, $height ) = $greffunc->get_geometry();
    }
    else {
        ( $width, $height ) = ( $SIZEUNIT, $SIZEUNIT );
    }

    if ( $gargs ) {
        ( $argw, $argh ) = $gargs->get_geometry();
        $height = $argh if $argh > $height;
    }

    return ( $width + $argw + ( $PADDING * 3 ), $height + ( $PADDING * 2 ) );
}

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my $SIZEUNIT = $self->SIZEUNIT();
    my $PADDING  = $self->PADDING();

    my ( $x, $y ) = $self->get_position();
    my ( $width, $height );
    my ( $argw, $argh );

    my $greffunc = $self->calls();
    my $gargs    = $self->args();

    if ( $greffunc ) {
        ( $width, $height ) = $greffunc->get_geometry();
    }
    else {
        ( $width, $height ) = ( $SIZEUNIT, $SIZEUNIT );
    }

    my $outer_box = $self->outer_box();
    $outer_box->set_position( $x, $y );
    $outer_box->set_geometry( $self->get_geometry() );
    $outer_box->draw( $cr );

    if ( $greffunc ) {
        $greffunc->set_position( $x + $PADDING, $y + $PADDING );
        $greffunc->draw( $cr );
    }

    if ( $gargs ) {
        $gargs->set_position( $x + $width + ( $PADDING * 2 ), $y + $PADDING );
        $gargs->draw( $cr );
    }

    $cr->restore();
}

1;
