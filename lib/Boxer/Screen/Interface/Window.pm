package Boxer::Screen::Interface::Window;

use Moose;
use Boxer::Screen::Interface::Heap;
use Boxer::Screen::Interface::WorkSpace;
use Boxer::Screen::Interface::Message;

with 'Boxer::Screen::Interface';

has 'screen' => (
    is  => 'rw',
    isa => 'Boxer::Screen',
    documentation => "Class for the main entry point into the user interface",
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

sub BUILD {
    my ( $self ) = @_;
    my $heap = Boxer::Screen::Interface::Heap->new();
    $heap->window( $self );
    $self->heap( $heap );

    my $work = Boxer::Screen::Interface::WorkSpace->new();
    $work->window( $self );
    $self->work( $work );

    my $message = Boxer::Screen::Interface::Message->new();
    $message->window( $self );
    $self->message( $message );
}

sub draw {
    my ( $self, $cr ) = @_;
    my ( $width, $height ) = $self->screen->win->get_size();

    my $SIZEUNIT = $self->SIZEUNIT();
    my $PADDING = $self->PADDING();

    my $MHEIGHT = $SIZEUNIT + ( $PADDING * 2 );

    $self->heap->set_position( $PADDING, $PADDING );
    $self->heap->set_geometry( 150, $height - ( $PADDING * 2 ) );
    $self->heap->draw( $cr );

    $self->work->set_position( ( $PADDING * 2 ) + 150, $PADDING );
    $self->work->set_geometry( $width - ( ( $PADDING * 3 ) + 150 ), $height - ( $PADDING * 3 ) - $MHEIGHT );
    $self->work->draw( $cr );

    $self->message->set_position( ( $PADDING * 2 ) + 150, $height - ( $MHEIGHT ) - $PADDING );
    $self->message->set_geometry( $width - ( ( $PADDING * 3 ) + 150 ), $MHEIGHT );
    $self->message->draw( $cr );
}

sub set_context {
    my ( $self, $item ) = @_;
    $self->work->context( $item );
}

sub set_message {
    my ( $self, $message ) = @_;
    $self->message->text( $message );
}

1;
