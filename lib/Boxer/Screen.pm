package Boxer::Screen;

use Moose;

use Cairo;
use Gtk2 qw/-init/;
use Glib qw/TRUE FALSE/;

use Boxer::GraphicManager;

has 'win'     => ( 'isa' => 'Gtk2::Window', 'is' => 'rw' );
has 'da'      => ( 'isa' => 'Gtk2::DrawingArea', 'is' => 'rw' );
has 'surface' => ( 'isa' => 'Cairo::ImageSurface', 'is' => 'rw' );
has 'objects' => ( 'isa' => 'ArrayRef', 'is' => 'rw' );
has 'runtime' => ( 'isa' => 'Ref', 'is' => 'rw' );
has 'needs_draw' => ( 'isa' => 'Int', 'is' => 'rw' );
has 'graphic_started' => ( 'isa' => 'Int', 'is' => 'rw' );
has 'graphic_manager' => ( 'isa' => 'Boxer::GraphicManager', 'is' => 'rw' );

sub BUILD {
    my ( $self ) = @_;

    $self->objects( [] );
    $self->graphic_manager( Boxer::GraphicManager->new() );

    $self->needs_draw( 1 );

    # The graphical environment
    $self->win( Gtk2::Window->new( 'toplevel' ) );
    $self->da( Gtk2::DrawingArea->new );
    $self->da->size( 500, 500 );
    $self->win()->signal_connect( key_press_event => sub { $self->handle_keypress( @_ ) } );

    my $vbox = Gtk2::VBox->new( 0, 5 );
    $vbox->pack_start( $self->da(), 0, 0, 0 );

    $self->win->set_default_size( 500, 500 );
    $self->win->add( $vbox );

    $self->da->signal_connect( expose_event => sub { $self->render( @_ ) } );

    $self->win->signal_connect( delete_event => sub { exit; } );

    $self->win->show_all;
}

sub create_surface {
    my ( $self ) = @_;
    my $surface = Cairo::ImageSurface->create( 'argb32', 500, 500 );
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

    my $list = $self->objects();
    for my $gobject ( @{ $list } ) {
        $gobject->draw( $cr );
    }
    $self->needs_draw( 0 );
}

sub add_objects {
    my ( $self, @objects ) = @_;
    my $list = $self->objects();
    push @{ $list }, $_ for @objects;
}

sub render {
    my ( $self, $widget, $event ) = @_;
    my $cr = Gtk2::Gdk::Cairo::Context->create( $widget->window );
    $cr->set_source_surface( $self->surface(), 0, 0 );
    $cr->paint;
    return FALSE;
}

sub add_main_ref {
    my ( $self ) = @_;

    my $mainref = $self->runtime->main();
    my $gobject = $self->graphic_manager->graphic_object_from_object( $mainref );
    die "could not find main object in graphic manager" if !defined $gobject;

    $gobject->set_position( 10, 10 );
    $self->add_objects( $gobject );
}

sub add_heap {
    my ( $self ) = @_;

    my $heapref = $self->runtime->heap();
    my $gobject = $self->graphic_manager->graphic_object_from_object( $heapref );
    die "could not find heap object in graphic manager" if !defined $gobject;

    $gobject->set_position( 10, 10 );
    $self->add_objects( $gobject );
}

sub run {
    my ( $self ) = @_;

    $self->create_surface();
    $self->do_cairo_drawing();

    $self->graphic_manager->process_pending_messages();

    #$self->add_main_ref();
    $self->add_heap();

    $self->needs_draw( 1 );

    while ( 1 ) {
        if ( $self->needs_draw() ) {
            $self->do_cairo_drawing();
            $self->invalidate_rect( 0, 0, 500, 500 );
            $self->needs_draw( 0 );
        }

        $self->runtime_iteration();
        my $needs_draw = $self->graphic_manager->process_pending_messages();
        $self->needs_draw( $needs_draw );

        while ( Gtk2->events_pending() ) {
            Gtk2->main_iteration();
        }
    }
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

    my $code2key = {
        65362 => 'up',
        65364 => 'down',
        65361 => 'left',
        65363 => 'right',
    };

    if ( $code2key->{$keyval} ) {
        $self->arrow_keypress( $code2key->{$keyval} );
    }

    $self->needs_draw( 1 );

    #my $server = $self->server();
    #$server->handle_keypress( $keyval ) if $keyval;

    return 1;
}

sub selected_heap {
    my ( $self, $sheap ) = @_;
    if ( defined $sheap ) {
        my $heapref = $self->runtime->heap();
        my $gobject = $self->graphic_manager->graphic_object_from_object( $heapref );
        my $current = $self->{selected_heap};
        if ( defined $current && $current != $sheap ) {
            $gobject->toggle_highlight_heap_element( $current, 0 );
        }
        $gobject->toggle_highlight_heap_element( $sheap, 1 );
        $self->{selected_heap} = $sheap;
    }
    return $self->{selected_heap};
}

sub arrow_keypress {
    my ( $self, $arrow ) = @_;

    my $index = $self->selected_heap();
    if ( !defined $index ) {
        $index = 0;
        $self->selected_heap( $index );
    }

    my $handler = {
        up => sub {
            my $heapref = $self->runtime->heap();
            my $length = $heapref->length();
            return if $length == 0;
            my $index = $self->selected_heap();
            if ( $index == 0 ) {
                $index = $length - 1;
                $self->selected_heap( $index );
            }
            else {
                $index--;
                $self->selected_heap( $index );
            }
        },
        down => sub {
            my $heapref = $self->runtime->heap();
            my $length = $heapref->length();
            return if $length == 0;
            my $index = $self->selected_heap();
            if ( $index >= ( $length - 1 ) ) {
                $index = 0;
                $self->selected_heap( $index );
            }
            else {
                $index++;
                $self->selected_heap( $index );
            }
        },
    };

    if ( $handler->{$arrow} ) {
        $handler->{$arrow}->();
    }
}

1;
