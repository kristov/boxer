package Boxer::Screen;

use Moose;

use Cairo;
use Gtk2 qw/-init/;
use Glib qw/TRUE FALSE/;

use Data::Dumper;

use Boxer::Test;

has 'win'     => ( 'isa' => 'Gtk2::Window', 'is' => 'rw' );
has 'da'      => ( 'isa' => 'Gtk2::DrawingArea', 'is' => 'rw' );
has 'surface' => ( 'isa' => 'Cairo::ImageSurface', 'is' => 'rw' );
has 'objects' => ( 'isa' => 'ArrayRef', 'is' => 'rw' );
has 'runtime' => ( 'isa' => 'Ref', 'is' => 'rw' );
has 'graphic_started' => ( 'isa' => 'Int', 'is' => 'rw' );

my %OBJECT;
my %USED;
my @MESSAGES;

sub BUILD {
    my ( $self ) = @_;

    $self->objects( [] );

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
    $_->draw( $cr ) for @{ $list };

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
    my $ref = "$mainref";
    my $addr;
    if ( $ref =~ /=HASH\(([0-9a-z]+)\)/ ) {
        $addr = $1;
    }
    else {
        die "$ref";
    }

    my $gobject = $OBJECT{$addr};
    die "could not find main object at $addr" if !defined $gobject;

    $gobject->set_position( 10, 10 );
    $self->add_objects( $gobject );
}

sub run {
    my ( $self ) = @_;

    $self->create_surface();
    $self->do_cairo_drawing();

    $self->process_messages() while @MESSAGES;

    $self->add_main_ref();

    while ( 1 ) {
        if ( $self->needs_draw() ) {
            $self->do_cairo_drawing();
            $self->invalidate_rect( 0, 0, 500, 500 );
            $self->needs_draw( 0 );
        }
        while ( Gtk2->events_pending() ) {
            Gtk2->main_iteration();
        }
        $self->runtime_iteration();
        $self->process_messages();
        #$self->needs_draw( 1 );
    }
}

sub runtime_iteration {
    my ( $self ) = @_;
    $self->runtime->iteration();
}

sub process_messages {
    my ( $self ) = @_;
    return if !@MESSAGES;
    my $message = shift( @MESSAGES );
    my ( $mainref, $action, $parts ) = @{ $message };
    $self->process_message( $mainref, $action, $parts );
}

sub send_message {
    my ( $self, $mainref, $action, $parts ) = @_;
    push @MESSAGES, [ $mainref, $action, $parts ];
}

sub process_message {
    my ( $self, $mainref, $action, $parts ) = @_;
    my ( $mainclass, $mainid ) = @{ $mainref };
    if ( $action eq 'new' ) {
        $self->create_graphic( $mainclass, $mainid );
        $self->needs_draw( 1 );
    }
    else {
        print "undefined action: $action for $mainclass\n";
    }
}

sub create_graphic {
    my ( $self, $mainclass, $mainid ) = @_;

    my $graphic_class = $mainclass;
    $graphic_class =~ s/Boxer::Object/Boxer::Graphic::Object/;
    if ( !$USED{$graphic_class} ) {
        eval "use $graphic_class; 1;" or do { die "Could not use $graphic_class: $@" };
    }
    my $graphic_object = $graphic_class->new();
    $OBJECT{$mainid} = $graphic_object;
}

sub needs_draw {
    my ( $self, $needs_draw ) = @_;
    $self->{needs_draw} = $needs_draw if defined $needs_draw;
    return $self->{needs_draw};
}

sub invalidate_rect {
    my ( $self, $x, $y, $width, $height ) = @_;
    my $update_rect = Gtk2::Gdk::Rectangle->new( $x, $y, $width, $height );
    $self->da->window->invalidate_rect( $update_rect, 0 );
}

sub handle_keypress {
    my ( $self, $widget, $event ) = @_;

    my $keyval = $event->keyval();
    $self->needs_draw( 1 );

    #my $server = $self->server();
    #$server->handle_keypress( $keyval ) if $keyval;

    return 1;
}

1;
