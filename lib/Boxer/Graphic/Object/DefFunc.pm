package Boxer::Graphic::Object::DefFunc;

use Moose;
use Boxer::Graphic::Widget::Box;

with 'Boxer::Graphic';
has 'outer_box' => ( isa => 'Boxer::Graphic::Widget::Box', is => 'rw' );

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
    $self->outer_box( Boxer::Graphic::Widget::Box->new() );
    $self->outer_box->fill( 1 );
}

sub thing_to_highlight {
    my ( $self ) = @_;
    return $self->outer_box();
}

sub get_geometry {
    my ( $self ) = @_;

    my $SIZEUNIT = $self->SIZEUNIT();
    my $PADDING = $self->PADDING();

    if ( !$self->expanded ) {
        return ( $SIZEUNIT, $SIZEUNIT );
    }

    my ( $width, $height ) = ( 0, 0 );

    my $args = $self->get_args();
    my ( $awidth, $aheight ) = ( 0, 0 );
    if ( $args ) {
        ( $awidth, $aheight ) = $args->get_geometry();
    }
    $width = $awidth if $awidth > $width;

    my $body = $self->get_body();
    my ( $bwidth, $bheight ) = ( 0, 0 );
    if ( $body ) {
        $body->orientation( 'vertical' );
        ( $bwidth, $bheight ) = $body->get_geometry();
    }
    $width = $bwidth if $bwidth > $width;

    if ( $width ) {
        $width += ( $PADDING * 2 );
    }
    else {
        $width = $SIZEUNIT;
    }
    if ( $aheight && $bheight ) {
        $height = $aheight + $bheight + ( $PADDING * 3 );
    }
    elsif ( $aheight ) {
        $height = $aheight + ( $PADDING * 2 );
    }
    elsif ( $bheight ) {
        $height = $bheight + ( $PADDING * 2 );
    }
    else {
        $height = $SIZEUNIT;
    }

    return ( $width, $height );
}

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my $PADDING  = $self->PADDING();

    my ( $x, $y ) = $self->get_position();

    my $outer_box = $self->outer_box();

    $outer_box->set_position( $x, $y );
    $outer_box->set_geometry( $self->get_geometry() );
    $outer_box->draw( $cr );
    $self->draw_icon( $cr, $x, $y ) if !$self->expanded;

    if ( $self->expanded ) {
        my $args = $self->get_args();
        my ( $awidth, $aheight ) = ( 0, 0 );
        if ( $args ) {
            ( $awidth, $aheight ) = $args->get_geometry();
            $args->set_position( $x + $PADDING, $y + $PADDING );
            $args->draw( $cr );
        }

        my $body = $self->get_body();
        if ( $body ) {
            $body->orientation( 'vertical' );
            if ( $aheight ) {
                $body->set_position( $x + $PADDING, $y + ( $PADDING * 2 ) + $aheight );
            }
            else {
                $body->set_position( $x + $PADDING, $y + $PADDING );
            }
            $body->draw( $cr );
        }
    }

    $cr->restore();
}

sub icon {
    return [
        {
            b => [ 0.4, 0.1, 0.1 ],
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
