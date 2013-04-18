package Boxer::Test;

use Moose;

use Boxer::Object::Array;
use Boxer::Graphic::Object::Array;

use Boxer::Graphic::Object::CallFunc;
use Boxer::Object::CallFunc;
use Boxer::Graphic::Object::RefFunc;
use Boxer::Object::RefFunc;

use Boxer::Object::Record;
use Boxer::Graphic::Object::Record;

sub test_object {
    my ( $self ) = @_;
    return $self->arglist();
    #return $self->callfunc();
    #return $self->record();
}

sub arglist {
    my ( $self ) = @_;

    my $array = Boxer::Object::Array->new();
    $array->push( 1 );
    $array->push( 2 );
    $array->push( 3 );

    my $garray = Boxer::Graphic::Object::Array->new();
    $garray->set_position( 100, 100 );
    $garray->array( $array );

    return $garray;
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
