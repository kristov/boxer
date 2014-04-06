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
    my ( $self, $runtime ) = @_;

    # create something like this:
    #
    # int addwrap ( int a, int b ) {
    #     return a + b;
    # }
    # int main () {
    #     addwrap( 5, 4 );
    # }

    # set up the type list for the function argument definition
    my $arg1 = Boxer::Object::Type::Number->new( $runtime );
    my $arg2 = Boxer::Object::Type::Number->new( $runtime );
    my $args = Boxer::Object::Array->new( $runtime );
    $args->PUSH( $arg1 );
    $args->PUSH( $arg2 );

    # links from arguments, into function body
    my $argref1 = Boxer::Object::ArgRef->new( $runtime );
    my $argref2 = Boxer::Object::ArgRef->new( $runtime );

    # connect arguments to arg refs
    $argref1->set_refs( $arg1 );
    $argref2->set_refs( $arg2 );

    # create args for add function call
    my $addargs = Boxer::Object::Array->new( $runtime );
    $addargs->PUSH( $argref1 );
    $addargs->PUSH( $argref2 );

    # create function call and add args to it
    my $addcall = Boxer::Object::CallFunc->new( $runtime );
    $addcall->set_args( $addargs );

    # create reference to add function, and link function call to it
    my $addref = Boxer::Object::Base::Add->new( $runtime );
    $addcall->set_calls( $addref );

    # the body of our function is a single call to add
    my $body = Boxer::Object::Array->new( $runtime );
    $body->PUSH( $addcall );

    # new function definition
    my $deffunc = Boxer::Object::DefFunc->new( $runtime );
    $deffunc->set_args( $args );
    $deffunc->set_body( $body );

    # create a reference to the defined function
    my $reffunc = Boxer::Object::RefFunc->new( $runtime );
    $reffunc->set_refs( $deffunc );

    # constants used in the function call
    my $num1 = Boxer::Object::Number->new( $runtime );
    my $num2 = Boxer::Object::Number->new( $runtime );
    $num1->set_value( 5 );
    $num2->set_value( 4 );

    # add constants to array used in function call
    my $callargs = Boxer::Object::Array->new( $runtime );
    $callargs->PUSH( $num1 );
    $callargs->PUSH( $num2 );

    # new function call, and add what it calls, and what vals it calls with
    my $maincall = Boxer::Object::CallFunc->new( $runtime );
    $maincall->set_calls( $reffunc );
    $maincall->set_args( $callargs );

    # the body of our function is a single call to add
    my $mainbody = Boxer::Object::Array->new( $runtime );
    $mainbody->PUSH( $maincall );

    # main function definition
    my $mainfunc = Boxer::Object::DefFunc->new( $runtime );
    $mainfunc->set_body( $mainbody );

    return $mainfunc;
}

1;
