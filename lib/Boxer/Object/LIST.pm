package Boxer::Object::LIST;

use Moose::Role;

has 'runtime' => (
    is  => 'rw',
    isa => 'Boxer::RunTime',
    documentation => "The runtime this object belongs to",
);

sub new {
    my ( $class, $runtime ) = @_;
    my $self = bless( { LIST => [] }, $class );
    $self->runtime( $runtime );

    $self->send_message( 'new' );
    $runtime->new_object( $self );

    $self->boxer_init() if $self->can( 'boxer_init' );
    return $self;
}

sub GET_INDEX {
    my ( $self, $index ) = @_;
    my $value = $self->{LIST}->[$index];
    $self->send_message( 'GET_INDEX', [ $index, $value ] );
}

sub SET_INDEX {
    my ( $self, $index, $value ) = @_;
    $self->{LIST}->[$index] = $value; # can be undef
    $self->send_message( 'SET_INDEX', [ $index, $value ] );
}

sub PUSH {
    my ( $self, $item ) = @_;
    my $record = $self->{LIST};
    push @{ $record }, $item;
    $self->send_message( 'PUSH', [ $item ] );
}

sub length {
    my ( $self, $item ) = @_;
    return scalar( @{ $self->{LIST} } );
}

sub send_message {
    my ( $self, $action, $data ) = @_;
    my $message = $self->create_message( $action, $data );
    $self->runtime->send_message( $message );
}

sub create_message {
    my ( $self, $action, $data ) = @_;

    my @itemaddrs;
    if ( $data ) {
        for my $item ( @{ $data } ) {
            my $itemaddr;
            if ( ref $item ) {
                $itemaddr = "$item";
            }
            else {
                $itemaddr = "Boxer::Object::CONSTANT=HASH($item)";
            }
            push @itemaddrs, $itemaddr;
        }
    }
    my $refaddr = "$self";

    return sprintf( '|%s|%s|%s|', $refaddr, $action, join( ',', @itemaddrs ) );
}

1;
