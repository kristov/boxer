#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw( $Bin );
use lib "$Bin/../lib";

use Boxer::Screen;
my $boxer = Boxer::Screen->new();
$boxer->run();
