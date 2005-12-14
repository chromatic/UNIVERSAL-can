#!perl

BEGIN
{
	chdir 't' if -d 't';
	use lib '../lib';
}

use strict;
use warnings;

use Test::More tests => 3;
use Test::Warn;
use Test::Exception;

# enable lexical warnings from module at compile time
BEGIN { use_ok( 'UNIVERSAL::can' ) }

=pod

This test is for the issue discussed in the PM post:

http://www.perlmonks.org/index.pl?node_id=516372

The errors which were reported were:

  Use of uninitialized value in split at
    /usr/local/share/perl/5.8.4/UNIVERSAL/can.pm line 51.
  Called UNIVERSAL::can() as a function, not a method at
    /usr/local/share/perl/5.8.4/Class/DBI.pm line 265
  Can't call method "can" on an undefined value at
    /usr/local/share/perl/5.8.4/UNIVERSAL/can.pm line 40.

Class::DBI line 265 is:

255 > my @pk_values = $self->_attrs($self->primary_columns);
265 > UNIVERSAL::can($_ => 'id') and $_ = $_->id for @pk_values;

In all likeliness Class::DBI line 265 really should be:

  eval { $_->can( $_ => 'id') } and $_ = $_->id
    for grep { defined $_ } @pk_values;

or something similar to prevent sending an undefined value to UNIVERSAL::can.

However, in the interest of making this module as useful as possible, it should
check for bad input and DWIM in those cases.

=cut

lives_ok
{
    warning_like { UNIVERSAL::can( undef, 'id') }
	    qr/^Called UNIVERSAL\:\:can\(\) as a function\, not a method/, 
        '... received exactly one warning here';
} '... test did not die';
