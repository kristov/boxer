package Boxer::GraphicManager;

use Moose;

has 'screen' => (
    is  => 'rw',
    isa => 'Boxer::Screen',
    documentation => "Screen to notify of updates",
);

my %SUPPORTED = qw(
    new    1
    calls  1
    args   1
    body   1
    push   1
    value  1
);

sub BUILD {
    my ( $self ) = @_;
    $self->{OBJECT}   = {};
    $self->{USED}     = {};
    $self->{MESSAGES} = [];
}

sub send_message {
    my ( $self, $mainref, $action, $parts ) = @_;
    push @{ $self->{MESSAGES} }, [ $mainref, $action, $parts ];
}

sub process_pending_messages {
    my ( $self ) = @_;
    
    my $needs_draw = 0;

    while ( my $message = shift( @{ $self->{MESSAGES} } ) ) {
        my ( $mainref, $action, $parts ) = @{ $message };
        my $something_needs_draw = $self->process_message( $mainref, $action, $parts );
        $needs_draw = 1 if $something_needs_draw;
    }

    return $needs_draw;
}

sub process_message {
    my ( $self, $mainref, $action, $parts ) = @_;

    my ( $mainclass, $mainid ) = @{ $mainref };
    if ( $action eq 'new' ) {
        $self->create_graphic( $mainclass, $mainid );
        return 1;
    }
    elsif ( $SUPPORTED{$action} ) {
        $self->dispatch_to_object( $mainid, $action, $parts );
        return 1;
    }
    else {
        print "unsupported action: $action for $mainclass\n";
    }

    return 0;
}

sub create_graphic {
    my ( $self, $mainclass, $mainid ) = @_;

    my $graphic_class = _graphic_class_from_object( $mainclass );

    if ( !$self->{USED}->{$graphic_class} ) {
        eval "use $graphic_class; 1;" or do { die "Could not use $graphic_class: $@" };
        $self->{USED}->{$graphic_class} = 1;
    }

    my $graphic_object = $graphic_class->new();
    $graphic_object->graphic_manager( $self );

    $self->{OBJECT}->{$mainid} = $graphic_object;
}

sub dispatch_to_object {
    my ( $self, $mainid, $action, $parts ) = @_;
    my $gobject = $self->graphic_object( $mainid );
    $gobject->dispatch( $action, $parts );
}

sub _graphic_class_from_object {
    my ( $gclass ) = @_;
    $gclass =~ s/Boxer::Object/Boxer::Graphic::Object/;
    return $gclass;
}

sub graphic_object_from_object {
    my ( $self, $object ) = @_;
    return $self->graphic_object( $self->id_from_object( $object ) );
}

sub id_from_object {
    my ( $self, $object ) = @_;
    my $ref = "$object";
    my $addr;
    if ( $ref =~ /=HASH\(([0-9a-z]+)\)/ ) {
        $addr = $1;
    }
    else {
        die "Could not recognize ref: $ref";
    }
    return $addr;
}

sub graphic_object {
    my ( $self, $id ) = @_;
    if ( exists $self->{OBJECT}->{$id} ) {
        return $self->{OBJECT}->{$id};
    }
    die "Could not find object for id $id";
}

1;
