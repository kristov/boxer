package Boxer::Graphic::Object::Number;

use Moose;
with 'Boxer::Graphic';

has 'outer_box' => (
    is  => 'rw',
    isa => 'Boxer::Graphic::Widget::Box',
);

has 'value' => (
    is  => 'rw',
    isa => 'Int',
    documentation => "The value of this constant",
);

use Boxer::Graphic::Widget::Box;

sub BUILD {
    my ( $self ) = @_;
    $self->outer_box( Boxer::Graphic::Widget::Box->new() );
    $self->outer_box->fill( 1 );
    $self->outer_box->color( [ 0.0, 0.6, 0.0 ] );
}

sub thing_to_highlight {
    my ( $self ) = @_;
    return $self->outer_box();
}

sub get_geometry {
    my ( $self ) = @_;
    my $SIZEUNIT = $self->SIZEUNIT();
    return ( $SIZEUNIT, $SIZEUNIT );
}

sub draw {
    my ( $self, $cr ) = @_;
    $cr->save();

    my $SIZEUNIT = $self->SIZEUNIT();
    my $PADDING = $self->PADDING();

    my ( $x, $y ) = $self->get_position();

    my $outer_box = $self->outer_box();
    $outer_box->set_position( $x, $y );
    $outer_box->set_geometry( $SIZEUNIT, $SIZEUNIT );
    $outer_box->draw( $cr );

    my $value = $self->value();
    if ( $value ) {
        $cr->set_source_rgb( 0.0, 0.2, 0.0 );
        $cr->select_font_face( "Sans", 'normal', 'normal' );
        $cr->set_font_size( 17.0 );
        $cr->move_to( $x + $PADDING, $y + $SIZEUNIT - $PADDING );
        $cr->show_text( $value );
    }

    $cr->restore();
}

1;
