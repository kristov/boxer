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

has 'mode' => (
    is  => 'rw',
    isa => 'Str',
    default => 'new',
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
        m     => sub { $self->mode eq 'new' ? $self->mode( 'traditional' ) : $self->mode( 'new' ) } 
    };
}

sub up {
    my ( $self ) = @_;
    my $context = $self->context();
    if ( $context ) {
        if ( $context->orientation() eq 'vertical' ) {
            $context->select_prev_item();
        }
        elsif ( $context->orientation() eq 'horizontal' ) {
            #$context = $context->parent();
            #$self->context( $context );
        }
    }
}

sub down {
    my ( $self ) = @_;
    my $context = $self->context();
    if ( $context ) {
        if ( $context->orientation() eq 'vertical' ) {
            $context->select_next_item();
        }
        elsif ( $context->orientation() eq 'horizontal' ) {
            #$context = $context->parent();
            #$self->context( $context );
        }
    }
}

sub left {
    my ( $self ) = @_;
    my $context = $self->context();
    if ( $context ) {
        if ( $context->orientation() eq 'vertical' ) {
            #$context = $context->parent();
            #$self->context( $context );
        }
        elsif ( $context->orientation() eq 'horizontal' ) {
            $context->select_prev_item();
        }
    }
}

sub right {
    my ( $self ) = @_;
    my $context = $self->context();
    if ( $context ) {
        if ( $context->orientation() eq 'vertical' ) {
            #$context = $context->parent();
            #$self->context( $context );
        }
        elsif ( $context->orientation() eq 'horizontal' ) {
            $context->select_next_item();
        }
    }
}

sub draw {
    my ( $self, $cr ) = @_;
    if ( $self->mode eq 'traditional' ) {
        $self->draw_traditional( $cr );
    }
    else {
        $self->draw_thing( $cr );
    }
}

sub draw_traditional {
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

sub draw_thing {
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
