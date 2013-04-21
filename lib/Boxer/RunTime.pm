package Boxer::RunTime;

use Moose;

has 'main' => ( isa => 'Boxer::Object::CallFunc', is => 'rw' );

sub run {
    my ( $self ) = @_;
    my $main = $self->main();
}

1;
