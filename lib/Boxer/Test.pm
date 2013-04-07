package Boxer::Test;

use Moose;

use Boxer::Graphic::Widget::ArgList;

use Boxer::Graphic::Object::CallFunc;
use Boxer::Object::CallFunc;
use Boxer::Graphic::Object::RefFunc;
use Boxer::Object::RefFunc;

use Boxer::Object::Record;
use Boxer::Graphic::Object::Record;

sub test_object {
    my ( $self ) = @_;
    #return $self->arglist();
    #return $self->callfunc();
    return $self->record();
}

sub arglist {
    my ( $self ) = @_;

    my $garglist = Boxer::Graphic::Widget::ArgList->new();
    $garglist->set_position( 100, 100 );
    $garglist->arg_list( [ 1, 2, 3, 4 ] );

    return $garglist;
}

sub callfunc {
    my ( $self ) = @_;

    my $garglist = Boxer::Graphic::Widget::ArgList->new();
    $garglist->arg_list( [ 1, 2, 3, 4 ] );

    my $reffunc = Boxer::Object::RefFunc->new();
    my $greffunc = Boxer::Graphic::Object::RefFunc->new();
    $greffunc->object( $reffunc );
    $greffunc->arglist( $garglist );
    $reffunc->graphic( $greffunc );

    my $callfunc = Boxer::Object::CallFunc->new();
    $callfunc->reffunc( $reffunc );

    my $gcallfunc = Boxer::Graphic::Object::CallFunc->new();
    $gcallfunc->object( $callfunc );

    $gcallfunc->set_position( 5, 5 );
    return $gcallfunc;
}

sub record {
    my ( $self ) = @_;

    my $record = Boxer::Object::Record->new();
    $record->data( {
        hello => 'Hi',
        from  => 'from',
        here  => 'Boxer',
    } );

    my $grecord = Boxer::Graphic::Object::Record->new();
    $grecord->set_position( 20, 20 );
    $grecord->object( $record );
    $record->graphic( $grecord );

    return $grecord;
}

no Moose;

1;
