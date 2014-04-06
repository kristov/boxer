package Boxer::Screen::CodeView::Traditional;

use Moose;

has 'work' => (
    is  => 'rw',
    isa => 'Object',
    documentation => "The workspace to render into",
);

sub draw {
    my ( $self, $cr, $main ) = @_;

    $cr->save();

    my ( $workx, $worky ) = $self->work->get_position();
    my ( $mainw, $mainh ) = $main->get_geometry();
    
    my ( $posx, $posy ) = ( $workx + 5, $worky + 5 );

    $main->set_position( $posx, $posy );
    $main->draw( $cr );

    my $main_body = $main->get_body();

    my $body_length = $main_body->length();

    for ( my $idx = 0; $idx < $body_length; $idx++ ) {
        my $item = $main_body->GET_INDEX( $idx );
        if ( ref( $item ) =~ /CallFunc/ ) {
            my $ref_func = $item->get_calls();
            my $def_func = $ref_func->get_refs();
            $posy += ( $mainh + 5 );
            $def_func->set_position( $posx, $posy );
            $def_func->draw( $cr );
        }
    }

    $cr->restore();
}

1;
