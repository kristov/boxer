package Boxer::TestCode;

use Moose;

use Boxer::Object::Base::Add;
use Boxer::Object::Type::Number;
use Boxer::Object::ArgRef;
use Boxer::Object::Array;
use Boxer::Object::Number;
use Boxer::Object::DefFunc;
use Boxer::Object::RefFunc;
use Boxer::Object::CallFunc;

sub test_code {
    my ( $self ) = @_;

    # create something like this:
    #
    # int addwrap ( int a, int b ) {
    #     return a + b;
    # }
    # int main () {
    #     addwrap( 5, 4 );
    # }

    # set up the type list for the function argument definition
    my $arg1 = Boxer::Object::Type::Number->new();
    my $arg2 = Boxer::Object::Type::Number->new();
    my $args = Boxer::Object::Array->new();
    $args->push( $arg1 );
    $args->push( $arg2 );

    # links from arguments, into function body
    my $argref1 = Boxer::Object::ArgRef->new();
    my $argref2 = Boxer::Object::ArgRef->new();

    # connect arguments to arg refs
    $argref1->refs( $arg1 );
    $argref2->refs( $arg2 );

    # create args for add function call
    my $addargs = Boxer::Object::Array->new();
    $addargs->push( $argref1 );
    $addargs->push( $argref2 );

    # create function call and add args to it
    my $addcall = Boxer::Object::CallFunc->new();
    $addcall->args( $addargs );

    # create reference to add function, and link function call to it
    my $addref = Boxer::Object::Base::Add->new();
    $addcall->calls( $addref );

    # the body of our function is a single call to add
    my $body = Boxer::Object::Array->new();
    $body->push( $addcall );

    # new function definition
    my $deffunc = Boxer::Object::DefFunc->new();
    $deffunc->args( $args );
    $deffunc->body( $body );

    # create a reference to the defined function
    my $reffunc = Boxer::Object::RefFunc->new();
    $reffunc->refs( $deffunc );

    # constants used in the function call
    my $num1 = Boxer::Object::Number->new();
    my $num2 = Boxer::Object::Number->new();
    $num1->value( 5 );
    $num2->value( 4 );

    # add constants to array used in function call
    my $callargs = Boxer::Object::Array->new();
    $callargs->push( $num1 );
    $callargs->push( $num2 );

    # new function call, and add what it calls, and what vals it calls with
    my $maincall = Boxer::Object::CallFunc->new();
    $maincall->calls( $reffunc );
    $maincall->args( $callargs );

    return $maincall;
}

1;
