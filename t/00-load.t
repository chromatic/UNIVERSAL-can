use Test::More tests => 3;

use_ok( 'UNIVERSAL::can' );

diag( "Testing UNIVERSAL::can $UNIVERSAL::can::VERSION, Perl $], $^X" );
can_ok( 'main', 'can' );
ok( defined &main::can );
