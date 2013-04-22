#!/usr/bin/env perl

use strict;
use warnings;
use lib qw( /home/ceade/src/personal/github/boxer/lib );
use Carp;
$SIG{__DIE__} = \&Carp::confess;
$SIG{__WARN__} = \&Carp::confess;

use Boxer::TestCode;
use Boxer::RunTime;
use Boxer::Screen;

my $runtime = Boxer::RunTime->new();
my $screen  = Boxer::Screen->new();

$runtime->screen( $screen );
$screen->runtime( $runtime );

$runtime->initialize();

my $mainref = Boxer::TestCode->test_code( $runtime );

$runtime->execute( $mainref );
