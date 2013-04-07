package Boxer::Graphic::Object::Record;

use Moose;

has 'outer_box' => ( isa => 'Boxer::Graphic::Box', is => 'rw' );
has 'record'    => ( isa => 'Boxer::Object::Record', is => 'rw' );

sub BUILD {
    my ( $self ) = @_;
    $self->outer_box( Boxer::Graphic::Box->new() );
}

sub draw {
    my ( $self, $cr ) = @_;

warn "draw()\n";

    $cr->save();

    my $record = $self->record();
    my $data = $record->data();

    my @keys = keys %{ $data };
    my $nr_keys = scalar( @keys );

    my $height = $nr_keys * 30;
    my $width  = 200;
    my $half_width = $width / 2;

    my $startx = 20;
    my $starty = 20;

    #$outer_box->height( $height + 40 );
    #$outer_box->width( $width + 40 );
    #$outer_box->draw( $cr );

    $cr->set_line_width( 2 );

    $cr->rectangle(
        $startx,
        $starty,
        $width,
        $height,
    );

    my $yfrom = $starty;
    for my $line_nr ( 1 .. ( $nr_keys - 1 ) ) {
        $yfrom += 30;
        $cr->move_to( $startx, $yfrom );
        $cr->line_to( $startx + $width, $yfrom );
    }
    $cr->move_to( $startx + $half_width, $starty );
    $cr->line_to( $startx + $half_width, $starty + $height );
    $cr->stroke();

    $cr->select_font_face( "Sans", 'normal', 'normal' );
    $cr->set_font_size( 20 );

    $yfrom = $starty;
    for my $key ( @keys ) {
        $cr->move_to( $startx + 10, $yfrom + 22 );
        $cr->show_text( $key );
        $cr->move_to( $startx + $half_width + 10, $yfrom + 22 );
        $cr->show_text( $data->{$key} );
        $yfrom += 30;
    }

    $cr->restore();
}

no Moose;

1;
