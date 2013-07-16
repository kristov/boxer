package Boxer::Graphic::Object::Record;

use Moose;
use Boxer::Graphic::Widget::Box;

with 'Boxer::Graphic';
has 'outer_box' => ( isa => 'Boxer::Graphic::Widget::Box', is => 'rw' );

use constant PADDING   => 10;
use constant KEYHEIGHT => 30;
use constant KEYWIDTH  => 100;

sub BUILD {
    my ( $self ) = @_;
    $self->outer_box( Boxer::Graphic::Widget::Box->new() );
    $self->outer_box->fill( 1 );
    $self->outer_box->color( [ 0.6, 0.8, 0.1 ] );
}

sub thing_to_highlight {
    my ( $self ) = @_;
    return $self->outer_box();
}

sub geometry {
    my ( $self ) = @_;

    my $record = $self->object();
    my $data = $record->data();

    my @keys = keys %{ $data };
    my $nr_keys = scalar( @keys );

    my $height = ( $nr_keys * KEYHEIGHT ) + ( PADDING * 2 ) + ( ( $nr_keys - 1 ) * PADDING );
    my $width  = ( KEYWIDTH * 2 ) + ( PADDING * 3 );

    return ( $width, $height );
}

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my $record = $self->object();
    my $data = $record->data();

    my @keys = keys %{ $data };
    my $nr_keys = scalar( @keys );

    my ( $width, $height ) = $self->geometry();

    my ( $x, $y ) = $self->get_position();
    my $startx = $x;
    my $starty = $y;

    my $outer_box = $self->outer_box();
    $outer_box->set_position( $startx, $starty );
    $outer_box->set_geometry( $width, $height );
    $outer_box->draw( $cr );

    my $box = Boxer::Graphic::Widget::Box->new();
    $box->set_position( $startx, $starty );
    $box->set_geometry( $width, $height );

    $startx += PADDING;
    $starty += PADDING;

    $box->color( [ 0.8, 0.8, 0.6 ] );
    for my $line_nr ( 1 .. $nr_keys ) {
        $box->set_position( $startx, $starty );
        $box->set_geometry( KEYWIDTH, KEYHEIGHT );
        $box->draw( $cr );

        $box->set_position( $startx + KEYWIDTH + PADDING, $starty );
        $box->set_geometry( KEYWIDTH, KEYHEIGHT );
        $box->draw( $cr );

        $starty += KEYHEIGHT + PADDING;
    }
    $starty = $y + PADDING;

    $cr->select_font_face( "Sans", 'normal', 'normal' );
    $cr->set_font_size( 20 );

    my $half_width = KEYWIDTH / 2;
    my $yfrom = $starty;
    for my $key ( @keys ) {
        $cr->move_to( $startx + 10, $starty + 22 );
        $cr->show_text( $key );

        $cr->move_to( $startx + KEYWIDTH + PADDING + 10, $starty + 22 );
        $cr->show_text( $data->{$key} );

        $starty += KEYHEIGHT + PADDING;
    }

    $cr->restore();
}

no Moose;

1;
