package Boxer::Object;

use Moose::Role;

has 'runtime' => (
    is  => 'rw',
    isa => 'Boxer::RunTime',
    documentation => "The runtime this object belongs to",
);

sub new {
    my ( $class, $runtime ) = @_;
    my $self = bless( {}, $class );
    $self->runtime( $runtime );

    $self->send_message( 'new' );
    $runtime->new_object( $self );

    $self->boxer_init() if $self->can( 'boxer_init' );
    return $self;
}

sub PROPERTY {
    my ( $self, $index, $name, $value ) = @_;
    if ( defined $value ) {
        $self->{$name} = $value;
        $self->send_message( $name, [ $value ] );
    }
    return $self->{$name};
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
