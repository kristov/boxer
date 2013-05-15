package Boxer::Graphic::Object::Number;

use Moose;
with 'Boxer::Graphic';
has 'box' => ( 'isa' => 'Boxer::Graphic::Widget::Box', 'is' => 'rw' );
has 'value' => ( isa => 'Int', is => 'rw' );

use Boxer::Graphic::Widget::Box;

sub BUILD {
    my ( $self ) = @_;
    $self->box( Boxer::Graphic::Widget::Box->new() );
    $self->box->fill( 1 );
    $self->box->color( [ 0.0, 0.6, 0.0 ] );
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

    my $box = $self->box();
    $box->set_position( $x, $y );
    $self->box->set_geometry( $SIZEUNIT, $SIZEUNIT );
    $box->draw( $cr );

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
