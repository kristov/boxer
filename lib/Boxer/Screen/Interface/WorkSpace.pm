package Boxer::Screen::Interface::WorkSpace;

use Moose;
use Boxer::Graphic::Widget::Box;
use Boxer::Screen::CodeView::Traditional;

with 'Boxer::Screen::Interface';

has 'window' => (
    is  => 'rw',
    isa => 'Boxer::Screen::Interface::Window',
    documentation => "The window this heap interface is connected to",
);

has 'codeview' => (
    is  => 'rw',
    isa => 'Boxer::Screen::CodeView::Traditional',
    builder => '_build_codeview',
    documentation => "Traditional code view",
);

has 'context' => (
    is  => 'rw',
    isa => 'Boxer::Graphic',
    documentation => "Thing being viewed",
);

sub _build_codeview {
    my ( $self ) = @_;
    my $codeview = Boxer::Screen::CodeView::Traditional->new();
    $codeview->work( $self );
    return $codeview;
}

sub keys {
    my ( $self ) = @_;
    return {
        up    => sub { $self->up() },
        down  => sub { $self->down() },
        left  => sub { $self->left() },
        right => sub { $self->right() },
    };
}

sub up {
    my ( $self ) = @_;
    my $context = $self->context();
    if ( $context ) {
        if ( $context->orientation() eq '' ) {
        }
        print STDERR "$context\n";
    }
}

sub down {
    my ( $self ) = @_;
    my $context = $self->context();
    if ( $context ) {
    }
}

sub left {
    my ( $self ) = @_;
    my $context = $self->context();
    if ( $context ) {
        my $parent = $context->parent();
        if ( !$parent ) {
            print STDERR "context $context has no parent, so it better be main()\n";
            return;
        }
        $self->context( $parent );
    }
}

sub right {
    my ( $self ) = @_;
    my $context = $self->context();
    if ( $context ) {
        my $next = $context->next();
        $self->context( $next );
    }
}

sub draw_new {
    my ( $self, $cr ) = @_;

    $cr->save();

    my ( $x, $y ) = $self->get_position();
    my ( $width, $height ) = $self->get_geometry();

    my $color = $self->highlighted
        ? [ 0.5, 0.5, 0.5 ]
        : [ 0.3, 0.3, 0.3 ];

    my $box = Boxer::Graphic::Widget::Box->new();
    $box->fill( 1 );
    $box->set_position( $x, $y );
    $box->set_geometry( $width, $height );
    $box->color( $color );
    $box->draw( $cr );

    my $codeview = $self->codeview();
    $codeview->draw( $cr, $self->window->screen->main() );

    $cr->restore();
}

sub draw {
    my ( $self, $cr ) = @_;

    $cr->save();

    my $context = $self->context();

    my $SIZEUNIT = $self->SIZEUNIT();
    my $PADDING = $self->PADDING();

    my ( $x, $y ) = $self->get_position();
    my ( $width, $height ) = $self->get_geometry();

    my $color = $self->highlighted
        ? [ 0.5, 0.5, 0.5 ]
        : [ 0.3, 0.3, 0.3 ];

    my $box = Boxer::Graphic::Widget::Box->new();
    $box->fill( 1 );
    $box->set_position( $x, $y );
    $box->set_geometry( $width, $height );
    $box->color( $color );
    $box->draw( $cr );

    if ( $context ) {
        $context->set_position( $x + $PADDING, $y + $PADDING );
        $context->draw( $cr );
    }

    $cr->restore();
}

1;
