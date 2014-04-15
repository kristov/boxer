package Boxer::Graphic;

use Moose::Role;
use Boxer::Graphic::Widget::Box;

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

has 'expanded' => (
    is  => 'rw',
    isa => 'Int',
    default => 1,
    documentation => "If set to 1, the element is expanded",
);

has 'never_expanded' => (
    is  => 'rw',
    isa => 'Int',
    default => 0,
    documentation => "If set to 1, the element is never expanded",
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

has color => (
    is  => 'rw',
    isa => 'ArrayRef',
    documentation => "Color of the main box",
);

has text => (
    is  => 'rw',
    isa => 'Str',
    documentation => "Alternative to icon",
);

has 'selected_index' => (
    is      => "rw",
    isa     => "Int",
    default => 0,
);

use constant PADDING => 5;
use constant SIZEUNIT => 20;

sub get_position {
    my ( $self ) = @_;
    return ( $self->x(), $self->y() );
}

sub set_position {
    my ( $self, $x, $y ) = @_;
    $self->x( $x );
    $self->y( $y );
}

sub select_prev_item {
    my ( $self ) = @_;

    my $length = $self->length();
    return if $length == 0;

    my $index = $self->selected_index();
    if ( $index == 0 ) {
        $self->highlight_element( $index, 0 );
        $index = $length - 1;
    }
    else {
        $self->highlight_element( $index, 0 );
        $index--;
    }
    $self->selected_index( $index );
    $self->highlight_element( $index, 1 );
}

sub select_next_item {
    my ( $self ) = @_;

    my $length = $self->length();
    return if $length == 0;

    my $index = $self->selected_index();
    if ( $index >= ( $length - 1 ) ) {
        $self->highlight_element( $index, 0 );
        $index = 0;
    }
    else {
        $self->highlight_element( $index, 0 );
        $index++;
    }
    $self->selected_index( $index );
    $self->highlight_element( $index, 1 );
}

sub enter_on_item {
    my ( $self ) = @_;
    my $index = $self->selected_index();
    $self->highlight_element( $index, 0 );
    my $array = $self->LIST();
    my $item = $array->[$index];
    $self->graphic_manager->screen->interface->set_context( $item );
}

sub highlight_element {
    my ( $self, $index, $highlight ) = @_;
    my $array = $self->LIST();
    my $item = $array->[$index];
    if ( defined $item ) {
        $item->highlight( $highlight );
        if ( $highlight ) {
            my $ref = "$item";
            $self->graphic_manager->screen->interface->set_message( $ref );
        }
    }
    else {
        die "item is not defined\n";
    }
}

sub highlight {
    my ( $self, $highlight ) = @_;
    $self->highlighted( $highlight );
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

sub get_geometry {
    my ( $self ) = @_;
    if ( !$self->expanded || $self->never_expanded ) {
        return $self->get_geometry_not_expanded();
    }
    else {
        return $self->get_geometry_expanded();
    }
}

sub draw {
    my ( $self, $cr ) = @_;
    if ( !$self->expanded || $self->never_expanded ) {
        $self->draw_not_expanded( $cr );
    }
    else {
        $self->draw_expanded( $cr );
    }
}

sub get_geometry_not_expanded {
    my ( $self ) = @_;
    return ( SIZEUNIT, SIZEUNIT );
}

sub draw_not_expanded {
    my ( $self, $cr ) = @_;
    $cr->save();
    my ( $x, $y ) = $self->get_position();

    my $box = Boxer::Graphic::Widget::Box->new();
    my $color = $self->color;
    $box->color( $color ) if $color;
    $box->fill( 1 );
    $box->highlighted( 1 ) if $self->highlighted();
    $box->set_position( $x, $y );
    $box->set_geometry( SIZEUNIT, SIZEUNIT );
    $box->draw( $cr );
    if ( $self->text ) {
        $cr->set_source_rgb( 0.0, 0.2, 0.0 );
        $cr->select_font_face( "Courier", 'normal', 'normal' );
        $cr->set_font_size( 17.0 );
        $cr->move_to( $x + PADDING, $y + SIZEUNIT - PADDING );
        $cr->show_text( $self->text );
    }
    else {
        $self->draw_icon( $cr, $x, $y ) if $self->can( 'icon' );
    }

    $cr->restore();
}

sub get_geometry_expanded {
    my ( $self ) = @_;

    my $orientation = $self->orientation();

    my $LIST = $self->LIST();
    my $length = 0;
    for my $item ( @{ $LIST } ) {
        $length++ if defined $item;
    }

    my $totaldim = 0;
    my ( $maxwidth, $maxheight ) = ( SIZEUNIT, SIZEUNIT );
    my ( $width, $height );

    if ( $length ) {
        my $list_orientation;
        if ( $self->can( 'list_orientation' ) ) {
            $list_orientation = $self->list_orientation();
        }
        my $idx = 0;
        for my $item ( @{ $LIST } ) {
            my $iorientation = 'horizontal';
            if ( $list_orientation ) {
                $iorientation = $list_orientation->[$idx];
            }
            $idx++;
            next if !defined $item;

            $item->orientation( $iorientation );

            my ( $iwidth, $iheight ) = $item->get_geometry();
            if ( $iwidth > $maxwidth ) {
                $maxwidth = $iwidth;
            }
            if ( $iheight > $maxheight ) {
                $maxheight = $iheight;
            }
            if ( $orientation eq 'vertical' ) {
                $totaldim += $iheight;
            }
            else {
                $totaldim += $iwidth;
            }
            $totaldim += PADDING;
        }
        $totaldim += PADDING;

        if ( $orientation eq 'vertical' ) {
            ( $width, $height ) = ( $maxwidth + ( PADDING * 2 ), $totaldim );
            $height += PADDING + SIZEUNIT; # for the icon
        }
        else {
            ( $width, $height ) = ( $totaldim, $maxheight + ( PADDING * 2 ) );
            $width += PADDING + SIZEUNIT; # for the icon
        }
    }
    else {
        ( $width, $height ) = ( SIZEUNIT, SIZEUNIT );
    }
    return ( $width, $height );
}

sub draw_expanded {
    my ( $self, $cr ) = @_;
    $cr->save();

    my ( $x, $y ) = $self->get_position();
    my $orientation = $self->orientation();

    my $LIST = $self->LIST();
    my $length = 0;
    for my $item ( @{ $LIST } ) {
        $length++ if defined $item;
    }

    my ( $width, $height ) = $self->get_geometry_expanded();

    my $box = Boxer::Graphic::Widget::Box->new();
    my $color = $self->color;
    $box->color( $color ) if $color;
    $box->fill( 1 );
    $box->highlighted( 1 ) if $self->highlighted();
    $box->set_position( $x, $y );
    $box->set_geometry( $width, $height );
    $box->draw( $cr );

    $x += PADDING;
    $y += PADDING;
    if ( $self->can( 'icon' ) ) {
        $self->draw_icon( $cr, $x, $y ) if $self->can( 'icon' );
        if ( $orientation eq 'vertical' ) {
            $y += SIZEUNIT;
            $y += PADDING;
        }
        else {
            $x += SIZEUNIT;
            $x += PADDING;
        }
    }

    if ( $length ) {
        for my $item ( @{ $LIST } ) {
            next if !defined $item;
            my ( $iwidth, $iheight ) = $item->get_geometry();
            $item->set_position( $x, $y );
            $item->draw( $cr );
            if ( $orientation eq 'vertical' ) {
                $y += $iheight;
                $y += PADDING;
            }
            else {
                $x += $iwidth;
                $x += PADDING;
            }
        }
    }

    $cr->restore();
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
