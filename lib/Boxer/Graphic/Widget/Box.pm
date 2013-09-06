package Boxer::Graphic::Widget::Box;

use Moose;

use constant M_PI => 3.1415;

with 'Boxer::Graphic';
has 'width'         => ( isa => 'Int', is => 'rw', default => 100 );
has 'height'        => ( isa => 'Int', is => 'rw', default => 100 );
has 'corner_radius' => ( isa => 'Int', is => 'rw', default => 5 );
has 'x'             => ( isa => 'Int', is => 'rw', default => 1 );
has 'y'             => ( isa => 'Int', is => 'rw', default => 1 );
has 'color'         => ( isa => 'ArrayRef', is => 'rw', default => sub { [ 0.2, 0.2, 0.9 ] } );
has 'fill'          => ( isa => 'Int', is => 'rw' );

sub set_geometry {
    my ( $self, $width, $height ) = @_;
    $self->height( $height );
    $self->width( $width );
}

sub get_geometry {
    my ( $self ) = @_;
    return ( $self->width(), $self->height() );
}

sub draw {
    my ( $self, $cr ) = @_;
    my $color  = $self->color();
    my $fill = $self->fill();
    $self->_draw( $fill, $color, $cr );
    if ( $self->highlighted() ) {
        $self->_draw( 0, [ 1.0, 0.9, 0.0 ], $cr );
    }
}

sub _draw {
    my ( $self, $fill, $color, $cr ) = @_;

    $cr->save();

    my $width  = $self->width();
    my $height = $self->height();
    my $radius = $self->corner_radius();
    my $x      = $self->x();
    my $y      = $self->y();

    $cr->set_line_width( 5 );

    $cr->move_to( $x + $radius, $y );
    $cr->arc( $x + $width - $radius, $y + $radius, $radius, M_PI * 1.5, M_PI * 2 );
    $cr->arc( $x + $width - $radius, $y + $height - $radius, $radius, 0, M_PI * .5 );
    $cr->arc( $x + $radius, $y + $height - $radius, $radius, M_PI * .5, M_PI );
    $cr->arc( $x + $radius, $y + $radius, $radius, M_PI, M_PI * 1.5 );
    $cr->set_source_rgb( @{ $color } );
    $cr->stroke() if !$fill;
    $cr->fill() if $fill;

    $cr->restore();
}

no Moose;

1;
