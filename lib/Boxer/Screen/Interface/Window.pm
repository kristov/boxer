package Boxer::Screen::Interface::Window;

use Moose;
use Boxer::Screen::Interface::Heap;
use Boxer::Screen::Interface::WorkSpace;

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

sub BUILD {
    my ( $self ) = @_;
    my $heap = Boxer::Screen::Interface::Heap->new();
    $heap->window( $self );
    $self->heap( $heap );

    my $work = Boxer::Screen::Interface::WorkSpace->new();
    $work->window( $self );
    $self->work( $work );
}

sub draw {
    my ( $self, $cr ) = @_;
    my ( $width, $height ) = $self->screen->win->get_size();

    $self->heap->set_position( 10, 10 );
    $self->heap->set_geometry( 150, $height - 20 );
    $self->heap->draw( $cr );

    $self->work->set_position( 20 + 150, 10 );
    $self->work->set_geometry( $width - ( 30 + 150 ), $height - 20 );
    $self->work->draw( $cr );
}

sub select_item {
    my ( $self, $item ) = @_;
}

1;
