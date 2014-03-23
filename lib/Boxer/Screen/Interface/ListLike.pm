package Boxer::Screen::Interface::ListLike;

use Moose::Role;

has 'selected_index' => (
    is      => "rw",
    isa     => "Int",
    default => 0,
);

sub keys {
    my ( $self ) = @_;
    return {
        up    => sub { $self->select_prev_item() },
        down  => sub { $self->select_next_item() },
        enter => sub { $self->trigger_hook( 'enter', $self->selected_index() ) },
    };
}

sub trigger_hook {
    my ( $self, $hook, @values ) = @_;
    return if !$self->can( 'hooks' );
    my $hooks = $self->hooks();
    if ( defined $hooks->{$hook} ) {
        $hooks->{$hook}->( @values );
    }
}

sub select_prev_item {
    my ( $self ) = @_;

    my $length = $self->length();
    return if $length == 0;

    my $index = $self->selected_index();
    if ( $index == 0 ) {
        $self->trigger_hook( 'unselected', $index );
        $index = $length - 1;
    }
    else {
        $self->trigger_hook( 'unselected', $index );
        $index--;
    }
    $self->selected_index( $index );
    $self->trigger_hook( 'selected', $index );
}

sub select_next_item {
    my ( $self ) = @_;

    my $length = $self->length();
    return if $length == 0;

    my $index = $self->selected_index();
    if ( $index >= ( $length - 1 ) ) {
        $self->trigger_hook( 'unselected', $index );
        $index = 0;
    }
    else {
        $self->trigger_hook( 'unselected', $index );
        $index++;
    }
    $self->selected_index( $index );
    $self->trigger_hook( 'selected', $index );
}

1;
