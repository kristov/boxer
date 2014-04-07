package Boxer::Screen::Interface::Window;

use Moose;
use Boxer::Screen::Interface::Clipboard;
use Boxer::Screen::Interface::Heap;
use Boxer::Screen::Interface::WorkSpace;
use Boxer::Screen::Interface::Message;

with 'Boxer::Screen::Interface';

has 'screen' => (
    is  => 'rw',
    isa => 'Boxer::Screen',
    documentation => "Class for the main entry point into the user interface",
);

has 'clipboard' => (
    is  => 'rw',
    isa => 'Boxer::Screen::Interface::Clipboard',
    documentation => "The heap interface",
);

has 'heap' => (
    is  => 'rw',
    isa => 'Boxer::Screen::Interface::Heap',
    documentation => "The heap interface",
);

has 'work' => (
    is  => 'rw',
    isa => 'Boxer::Screen::Interface::WorkSpace',
    documentation => "The working area interface",
);

has 'message' => (
    is  => 'rw',
    isa => 'Boxer::Screen::Interface::Message',
    documentation => "A message area",
);

has 'current_interface' => (
    is  => 'rw',
    isa => 'Object',
    documentation => "",
);

sub keys {
    my ( $self ) = @_;
    return {
        tab    => sub { $self->tab_pressed },
        _other => sub { $self->dispatch_to_context( @_ ) },
    };
}

sub BUILD {
    my ( $self ) = @_;

    my $clipboard = Boxer::Screen::Interface::Clipboard->new();
    $clipboard->window( $self );
    $self->clipboard( $clipboard );

    my $heap = Boxer::Screen::Interface::Heap->new();
    $heap->window( $self );
    $self->heap( $heap );

    my $work = Boxer::Screen::Interface::WorkSpace->new();
    $work->window( $self );
    $self->work( $work );

    my $message = Boxer::Screen::Interface::Message->new();
    $message->window( $self );
    $self->message( $message );

    $heap->highlight( 1 );
    $self->context( $heap );
}

sub draw {
    my ( $self, $cr ) = @_;

    my ( $width, $height ) = $self->screen->win->get_size();

    my $SIZEUNIT = $self->SIZEUNIT();
    my $PADDING = $self->PADDING();

    my $heap_width = 40;
    my $message_height = $SIZEUNIT + ( $PADDING * 2 );
    my $clip_height = $SIZEUNIT + ( $PADDING * 2 );

    my $work_width = $width - ( ( $PADDING * 3 ) + $heap_width );
    my $work_height = $height - ( $PADDING * 3 ) - $message_height;

    #$self->clipboard->set_position( $PADDING, $PADDING );
    #$self->clipboard->set_geometry( $heap_width, $clip_height );
    #$self->clipboard->draw( $cr );

    #$self->heap->set_position( $PADDING, $clip_height + ( $PADDING * 2 ) );
    #$self->heap->set_geometry( $heap_width, $height - ( $PADDING * 3 ) - $clip_height );
    $self->heap->set_position( $PADDING, $PADDING );
    $self->heap->set_geometry( $heap_width, $height - ( $PADDING * 2 ) );
    $self->heap->draw( $cr );

    $self->work->set_position( $heap_width + ( $PADDING * 2 ), $PADDING );
    $self->work->set_geometry( $work_width, $work_height );
    $self->work->draw( $cr );

    $self->message->set_position( $heap_width + ( $PADDING * 2 ), $height - ( $message_height ) - $PADDING );
    $self->message->set_geometry( $work_width, $message_height );
    $self->message->draw( $cr );
}

sub tab_pressed {
    my ( $self ) = @_;
    my $context = $self->context();
    if ( ref( $context ) =~ /Heap/ ) {
        $self->heap->highlight( 0 );
        $self->work->highlight( 1 );
        $self->context( $self->work );
    }
    else {
        $self->heap->highlight( 1 );
        $self->work->highlight( 0 );
        $self->context( $self->heap );
    }
}

sub dispatch_to_context {
    my ( $self, $key ) = @_;
    $self->context->dispatch_keypress( $key );
}

sub set_context {
    my ( $self, $item ) = @_;
    $self->clipboard->clipboard( $item );
    $self->work->context( $item );
}

sub set_message {
    my ( $self, $message ) = @_;
    $self->message->text( $message );
}

1;
