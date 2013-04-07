package Boxer::Screen;

use Moose;

use Cairo;
use Gtk2 qw/-init/;
use Glib qw/TRUE FALSE/;

use Boxer::Object::Record;
use Boxer::Graphic::Object::Record;
use Boxer::Graphic::Box;

has 'win'     => ( isa => 'Gtk2::Window',        is => 'rw' );
has 'da'      => ( isa => 'Gtk2::DrawingArea',   is => 'rw' );
has 'surface' => ( isa => 'Cairo::ImageSurface', is => 'rw' );
has 'objects' => ( isa => 'ArrayRef',            is => 'rw' );

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

=item

    my $padding = 10;
    my $x = 10;
    my $y = 10;
    my $objects = $self->objects();
    foreach my $object ( @{ $objects } ) {
        my $object_height = $object->height();
        $object->move( $x, $y );
        $object->draw( $cr );
        $object->needs_draw( 0 );
        $y = $y + $object_height + $padding;
    }

=cut

    my $list = $self->objects();
    $_->draw( $cr ) for @{ $list };

    $self->needs_draw( 0 );
}

sub add_objects {
    my ( $self, @objects ) = @_;
    my $list = $self->objects();
    push @{ $list }, $_ for @objects;
}

sub test_record {
    my ( $self ) = @_;

    my $record = Boxer::Object::Record->new();
    $record->data( {
        hello => 'Hi',
        from  => 'from',
        here  => 'Boxer',
    } );

    my $grecord = Boxer::Graphic::Object::Record->new();
    $grecord->record( $record );

    return $grecord;
}

sub render {
    my ( $self, $widget, $event ) = @_;
    my $cr = Gtk2::Gdk::Cairo::Context->create( $widget->window );
    $cr->set_source_surface( $self->surface(), 0, 0 );
    $cr->paint;
    return FALSE;
}

sub run {
    my ( $self ) = @_;

    $self->add_objects( $self->test_record() );

    $self->create_surface();
    $self->do_cairo_drawing();

    while ( 1 ) {
        if ( $self->needs_draw() ) {
            $self->do_cairo_drawing();
            $self->invalidate_rect( 0, 0, 500, 500 );
        }
        while ( Gtk2->events_pending() ) {
            Gtk2->main_iteration();
        }
    }
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

    my $list = $self->objects();
    my $grecord = $list->[0];
    my $record = $grecord->record();
    my $data = $record->data();
    $data->{Foo} = '10';
    $self->needs_draw( 1 );

    #my $server = $self->server();
    #$server->handle_keypress( $keyval ) if $keyval;

    return 1;
}

no Moose;

1;
