package Boxer::Graphic::Object::Array;

use Moose;
use Boxer::Graphic::Widget::Box;

with 'Boxer::Graphic';

has 'outer_box' => (
    is  => 'rw',
    isa => 'Boxer::Graphic::Widget::Box',
);

has orientation => (
    is  => 'rw',
    isa => 'Str',
    default => 'horizontal',
    documentation => "Render this array horizontal or vertical",
);

sub BUILD {
    my ( $self ) = @_;
    $self->outer_box( Boxer::Graphic::Widget::Box->new() );
    $self->outer_box->fill( 1 );
}

sub thing_to_highlight {
    my ( $self ) = @_;
    return $self->outer_box();
}

sub push {
    my ( $self, $item ) = @_;
    $self->{array} ||= [];
    push @{ $self->{array} }, $item;
}

sub pop {
}

sub get_geometry {
    my ( $self ) = @_;

    my $SIZEUNIT = $self->SIZEUNIT();
    my $PADDING  = $self->PADDING();

    my $orientation = $self->orientation();

    my ( $x, $y ) = $self->get_position();
    my $array = $self->{array};

    my ( $width, $height );

    my $nr_items  = scalar( @{ $array } );
    my $nr_spaces = 0;

    if ( $orientation eq 'horizontal' ) {
        if ( $nr_items > 0 ) {
            $nr_spaces = $nr_items; # Would be -1, but add one for the handle
        }
        $width = ( $nr_items * $SIZEUNIT ) + ( $nr_spaces * $PADDING );
        $width += $SIZEUNIT;
        $height = $SIZEUNIT;
    }
    elsif ( $orientation eq 'vertical' ) {
        if ( $nr_items > 0 ) {
            $nr_spaces = $nr_items - 1;
        }
        my $max_width = $SIZEUNIT;
        for my $item ( @{ $array } ) {
            my ( $iwidth, $iheight ) = $item->get_geometry();
            $height += $iheight;
            $max_width = $iwidth if $iwidth > $max_width;
        }
        $height += ( $nr_spaces * $PADDING ) + ( $PADDING * 2 );
        $width = $max_width + ( $PADDING * 2 );
    }

    return ( $width, $height );
}

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my $SIZEUNIT = $self->SIZEUNIT();
    my $PADDING  = $self->PADDING();

    my $orientation = $self->orientation();

    my ( $x, $y ) = $self->get_position();
    my $array = $self->{array};

    my $nr_items = scalar( @{ $array } );

    if ( $orientation eq 'horizontal' ) {
        my $box = $self->outer_box();
        $box->set_position( $x, $y );
        $box->set_geometry( $SIZEUNIT, $SIZEUNIT );
        $box->color( [ 0.6, 0.6, 0.1 ] );
        $box->draw( $cr );

        $x += ( $SIZEUNIT + $PADDING );
        for my $thing ( 1 .. $nr_items ) {
            my $idx = $thing - 1;
            $box->set_position( $x, $y );
            $box->set_geometry( $SIZEUNIT, $SIZEUNIT );
            $box->color( [ 0.1, 0.6, 0.6 ] );
            $box->draw( $cr );
            $x += ( $SIZEUNIT + $PADDING );
        }
    }
    elsif ( $orientation eq 'vertical' ) {
        my ( $width, $height ) = $self->get_geometry();
        my $box = $self->outer_box();
        $box->set_position( $x, $y );
        $box->set_geometry( $width, $height );
        $box->color( [ 1.0, 0.4, 0.0 ] );
        $box->draw( $cr );

        $x += $PADDING;
        $y += $PADDING;
        for my $item ( @{ $array } ) {
            my ( $iwidth, $iheight ) = $item->get_geometry();
            $item->set_position( $x, $y );
            $item->draw( $cr );
            $y += ( $iheight + $PADDING );
        }
    }

    $cr->restore();
}

1;
