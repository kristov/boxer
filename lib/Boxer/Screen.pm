package Boxer::Screen;

use Moose;

use Cairo;
use Gtk2 qw/-init/;
use Glib qw/TRUE FALSE/;

use Boxer::GraphicManager;
use Boxer::Screen::Interface::Window;

has 'win' => (
    is  => 'rw',
    isa => 'Gtk2::Window',
    documentation => "GTK window",
);

has 'da' => (
    is  => 'rw',
    isa => 'Gtk2::DrawingArea',
    documentation => "GTK drawing area",
);

has 'vbox' => (
    is  => 'rw',
    isa => 'Gtk2::VBox',
    documentation => "Where to add the drawing area",
);

has 'surface' => (
    is  => 'rw',
    isa => 'Cairo::ImageSurface',
    documentation => "Cairo surface we are drawing to",
);

has 'runtime' => (
    is  => 'rw',
    isa => 'Ref',
    documentation => "The module executing the code",
);

has 'w' => (
    is  => 'rw',
    isa => 'Int',
    documentation => "Window width",
);

has 'h' => (
    is  => 'rw',
    isa => 'Int',
    documentation => "Window height",
);

has 'needs_draw' => (
    is  => 'rw',
    isa => 'Int',
    documentation => "Do we need to redraw the screen?",
);

has 'graphic_started' => (
    is  => 'rw',
    isa => 'Int',
    documentation => "Has the graphical environment been initialized yet?",
);

has 'interface' => (
    is  => 'rw',
    isa => 'Boxer::Screen::Interface::Window',
    documentation => "The main user interface",
);

has 'graphic_manager' => (
    is  => 'rw',
    isa => 'Boxer::GraphicManager',
    documentation => "This coordinating messages between code and graphics",
);

sub BUILD {
    my ( $self ) = @_;

    $self->graphic_manager( Boxer::GraphicManager->new() );
    $self->graphic_manager->screen( $self );

    $self->interface( Boxer::Screen::Interface::Window->new() );
    $self->interface->screen( $self );
    $self->interface->set_position( 0, 0 );

    $self->needs_draw( 1 );

    my ( $width, $height ) = $self->get_geometry();

    # The graphical environment
    $self->win( Gtk2::Window->new( 'toplevel' ) );
    $self->win->set_default_size( $width, $height );
    $self->win()->signal_connect( key_press_event => sub { $self->handle_keypress( @_ ) } );

    $self->vbox( Gtk2::VBox->new( 0, 5 ) );

    $self->da( Gtk2::DrawingArea->new );
    $self->da->size( $width, $height );
    $self->da->signal_connect( expose_event => sub { $self->render( @_ ) } );
    $self->vbox->pack_start( $self->da, 0, 0, 0 );

    my $color = Gtk2::Gdk::Color->new( 0, 0, 0 );
    $self->da->modify_bg( 'normal', $color );

    $self->win->add( $self->vbox );

    $self->win->signal_connect( delete_event => sub { exit; } );

    $self->win->show_all;
}

sub set_geometry {
    my ( $self, $w, $h ) = @_;
    $self->w( $w );
    $self->h( $h );
}

sub get_geometry {
    my ( $self ) = @_;
    return ( $self->w, $self->h );
}

sub create_surface {
    my ( $self ) = @_;
    my ( $width, $height ) = $self->get_geometry();
    my $surface = Cairo::ImageSurface->create( 'argb32', $width, $height );
    $self->surface( $surface );
}

sub do_cairo_drawing {
    my ( $self ) = @_;

    # Create surface every redraw - prevents drawing over the top of stuff (sometimes
    # the text anti-aliasing "bleeds out" if you redraw the same text over the top)
    $self->create_surface();

    my $surface = $self->surface();
    my $cr = Cairo::Context->create( $surface );

#    $cr->set_source_rgb( 0, 0, 0 );
#    $cr->select_font_face( "Sans", 'normal', 'normal' );
#    $cr->set_font_size( 40.0 );
#    $cr->move_to( 10, 50 );
#    $cr->show_text( "Disziplin ist Macht." );
#    my $rgb2 = [ 0.8, 0.4, 0 ];

    $self->interface->draw( $cr );
    $self->needs_draw( 0 );
}

sub render {
    my ( $self, $widget, $event ) = @_;
    my $cr = Gtk2::Gdk::Cairo::Context->create( $widget->window );
    $cr->set_source_surface( $self->surface(), 0, 0 );
    $cr->paint;
    return FALSE;
}

sub clipboard {
    my ( $self ) = @_;
    return $self->{clipboard};
}

sub heap {
    my ( $self ) = @_;
    my $heap = $self->runtime->heap();
    my $gobject = $self->graphic_manager->graphic_object_from_object( $heap );
    return $gobject;
}

sub main {
    my ( $self ) = @_;
    my $main = $self->runtime->main();
    my $gobject = $self->graphic_manager->graphic_object_from_object( $main );
    return $gobject;
}

sub run {
    my ( $self ) = @_;

    $self->create_surface();
    $self->interface->set_position( 10, 10 );

    $self->graphic_manager->process_pending_messages();
    $self->do_cairo_drawing();

    #Glib::Timeout->add( 10, sub { $self->process_timer } );
    $self->needs_draw( 1 );
    $self->process;

    Gtk2->main();
}

sub process_timer {
    my ( $self ) = @_;
    $self->process;
}

sub process {
    my ( $self ) = @_;

    if ( $self->needs_draw ) {
        $self->do_cairo_drawing();
        my ( $width, $height ) = $self->get_geometry();
        $self->invalidate_rect( 0, 0, $width, $height );
        $self->needs_draw( 0 );
    }

    $self->runtime_iteration();
    my $needs_draw = $self->graphic_manager->process_pending_messages();
    $self->needs_draw( $needs_draw );
}

sub runtime_iteration {
    my ( $self ) = @_;
    $self->runtime->iteration();
}

sub send_message {
    my ( $self, $mainref, $action, $parts ) = @_;
    $self->graphic_manager->send_message( $mainref, $action, $parts );
}

sub invalidate_rect {
    my ( $self, $x, $y, $width, $height ) = @_;
    my $update_rect = Gtk2::Gdk::Rectangle->new( $x, $y, $width, $height );
    $self->da->window->invalidate_rect( $update_rect, 0 );
}

sub handle_keypress {
    my ( $self, $widget, $event ) = @_;

    my $keyval = $event->keyval();

    my $directional = {
        'up',
        'down',
        'left',
        'right',
    };

    my $code2key = {
        65362 => 'up',
        65364 => 'down',
        65361 => 'left',
        65363 => 'right',
        65293 => 'enter',
        65289 => 'tab',
        105   => 'i',
        109   => 'm',
    };

    if ( $code2key->{$keyval} ) {
        $self->interface->dispatch_keypress( $code2key->{$keyval} );
    }
    else {
        print "unknown key: $keyval\n";
    }

    $self->needs_draw( 1 );
    $self->process;

    return 1;
}

1;
