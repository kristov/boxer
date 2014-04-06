package Boxer::Graphic;

use Moose::Role;

has 'graphic_manager' => (
    is  => 'rw',
    isa => 'Boxer::GraphicManager',
    documentation => "The manager of graphic objects",
);

has 'x' => (
    is  => 'rw',
    isa => 'Int',
    documentation => "The x position of this element within its parent",
);

has 'y' => (
    is  => 'rw',
    isa => 'Int',
    documentation => "The y position of this element within its parent",
);

has 'highlighted' => (
    is  => 'rw',
    isa => 'Int',
    default => 0,
    documentation => "If set to 1, the element is highlighted in some way",
);

has 'PADDING' => (
    is  => 'rw',
    isa => 'Int',
    default => 5,
    documentation => "How much padding should be used for child elements",
);

has 'SIZEUNIT' => (
    is  => 'rw',
    isa => 'Int',
    default => 20,
    documentation => "How large should the element be rendered",
);

has 'parent' => (
    is  => 'rw',
    isa => 'Object',
    documentation => "The logical parent of the object",
);

has orientation => (
    is  => 'rw',
    isa => 'Str',
    default => 'horizontal',
    documentation => "Render this array horizontal or vertical",
);

sub get_position {
    my ( $self ) = @_;
    return ( $self->x(), $self->y() );
}

sub set_position {
    my ( $self, $x, $y ) = @_;
    $self->x( $x );
    $self->y( $y );
}

sub highlight {
    my ( $self, $highlight ) = @_;
    my $thing = $self->thing_to_highlight();
    if ( defined $thing ) {
        $thing->highlighted( $highlight );
    }
    else {
        die "I dont have a thing_to_highlight!";
    }
}

sub BUILD {
    my ( $self ) = @_;
    $self->{LIST} = [];
}

sub length {
    my ( $self ) = @_;
    my $array = $self->LIST();
    return scalar( @{ $array } );
}

sub PUSH {
    my ( $self, $value ) = @_;
    $value->parent( $self ) if ref $value;
    push @{ $self->{LIST} }, $value;
}

sub SET_INDEX {
    my ( $self, $index, $value ) = @_;
    $value->parent( $self ) if ref $value;
    $self->{LIST}->[$index] = $value;
}

sub GET_INDEX {
    my ( $self, $index ) = @_;
    return $self->{LIST}->[$index];
}

sub LIST {
    my ( $self ) = @_;
    return $self->{LIST};
}

sub dispatch_keypress {
    my ( $self, $key ) = @_;

    next if !$self->can( 'keys' );

    my $keys = $self->keys();
    if ( defined $keys->{$key} ) {
        $keys->{$key}->();
    }
}

sub dispatch {
    my ( $self, $action, $parts ) = @_;
    if ( $self->can( $action ) ) {
        my $manager = $self->graphic_manager();
        my @args;
        for my $part ( @{ $parts } ) {
            my $gobject;
            if ( $part->[0] =~ /CONSTANT$/ ) {
                $gobject = $part->[1];
            }
            else {
                $gobject = $manager->graphic_object( $part->[1] );
            }
            push @args, $gobject;
        }
        $self->$action( @args );
    }
    else {
        print "Boxer::Graphic::dispatch() $self object can not $action\n";
    }
}

sub _icon_text_to_data {
    my ( $icon_text ) = @_;
    my $data = [];
    $icon_text =~ s/\s//g;
    my @pixels = split( //, $icon_text );
    my $ptr = 0;
    for my $y ( 0 .. 15 ) {
        for my $x ( 0 .. 15 ) {
            $data->[$y]->[$x] = $pixels[$ptr];
            $ptr++;
        }
    }
    return $data;
}

sub draw_icon {
    my ( $self, $cr, $xpos, $ypos ) = @_;

    $xpos += 2;
    $ypos += 2;

    my ( $color_table, $icon_text ) = @{ $self->icon };
    my $data = _icon_text_to_data( $icon_text );

    $cr->save();
    $cr->set_line_width( 0.5 );

    for my $y ( 0 .. 15 ) {
        for my $x ( 0 .. 15 ) {
            my $col = $data->[$y]->[$x];
            next if !$color_table->{$col};
            my $color = $color_table->{$col};
            $cr->set_source_rgb( @{ $color } );
            $cr->rectangle( $xpos + $x, $ypos + $y, 1, 1 );
            $cr->stroke();
            $cr->fill();
        }
    }

    $cr->restore();
}

1;
