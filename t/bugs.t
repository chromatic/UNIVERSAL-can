#!/usr/bin/perl

use strict;

use Test::More 'no_plan';    # tests => 8;

BEGIN { use_ok( 'UNIVERSAL::can', 'can' ) }

# valid use of isa() as static method on undefined class
{
    my $warnings = '';
    local $SIG{__WARN__} = sub { $warnings .= shift };
    use warnings 'UNIVERSAL::can';

    ok( !UnloadedClass->can('can'),
        'unloaded class should not be able to can()' );
    is( $warnings, '', '... and should not warn' );
}
