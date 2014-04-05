package Boxer::Graphic::Object::DefFunc;

use Moose;
use Boxer::Graphic::Widget::Box;

with 'Boxer::Graphic';
has 'outer_box' => ( isa => 'Boxer::Graphic::Widget::Box', is => 'rw' );

sub body {
    my ( $self, $gobject ) = @_;
    if ( defined $gobject ) {
        $self->{body} = $gobject;
        $gobject->parent( $self );
    }
    return $self->{body};
}

sub args {
    my ( $self, $gobject ) = @_;
    if ( defined $gobject ) {
        $self->{args} = $gobject;
        $gobject->parent( $self );
    }
    return $self->{args};
}

sub next {
    my ( $self ) = @_;
    return $self->{body};
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

    my $args = $self->args();
    my ( $width, $height );
    if ( $args ) {
        ( $width, $height ) = $args->get_geometry();
    }
    else {
        ( $width, $height ) = ( $SIZEUNIT, $SIZEUNIT );
    }

    my $body = $self->body();
    if ( $body ) {
        $body->orientation( 'vertical' );
        my ( $bwidth, $bheight ) = $body->get_geometry();
        $width = $bwidth if $bwidth > $width;
        $height += $bheight + $PADDING;
    }

    return ( $width + ( $PADDING * 2 ), $height + ( $PADDING * 2 ) );
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

    my $args = $self->args();
    my ( $awidth, $aheight );
    if ( $args ) {
        ( $awidth, $aheight ) = $args->get_geometry();
        $args->set_position( $x + $PADDING, $y + $PADDING );
        $args->draw( $cr );
    }

    my $body = $self->body();
    if ( $body ) {
        $body->set_position( $x + $PADDING, $y + ( $PADDING * 2 ) + $aheight );
        $body->draw( $cr );
    }

    $cr->restore();
}

1;
