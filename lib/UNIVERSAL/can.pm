package UNIVERSAL::can;

use strict;
use warnings;

use vars qw( $VERSION $recursing );
$VERSION = '1.02';

use Scalar::Util 'blessed';
use warnings::register;

my $orig;

BEGIN
{
	$orig = \&UNIVERSAL::can;

	no warnings 'redefine';
	*UNIVERSAL::can = \&can;
}

sub can
{
	return _report_warning() unless defined $_[0];

	goto &$orig if $recursing;
	goto &$orig unless _is_invocant( $_[0] );

	local $@;
	my $can = eval { $_[0]->$orig( 'can' ) || 0 };
	goto &$orig if $can == \&UNIVERSAL::can;

	local $recursing = 1;
	my $invocant     = shift;

	_report_warning();
	return $invocant->can( @_ );
}

sub _report_warning
{
	if (warnings::enabled())
	{
		my $calling_sub  = ( caller( 2 ) )[3] || '';
		warnings::warn( "Called UNIVERSAL::can() as a function, not a method" )
			if $calling_sub !~ /::can$/;
	}

	return;
}

sub _is_invocant
{
	my $potential = shift;
	return 1 if blessed( $potential );

	my $symtable = \%::;
	my $found    = 1;

	for my $symbol ( split( /::/, $potential ) )
	{
		$symbol .= '::';
		unless ( exists $symtable->{ $symbol } )
		{
			$found = 0;
			last;
		}

		$symtable = $symtable->{ $symbol };
	}

	return $found;
}

1;
__END__

=head1 NAME

UNIVERSAL::can - Hack around people calling UNIVERSAL::can() as a function

=head1 VERSION

Version 1.01

=head1 SYNOPSIS

To use this module, simply:

  use UNIVERSAL::can;

=head1 DESCRIPTION

The UNIVERSAL class provides a few default methods so that all objects can use
them.  Object orientation allows programmers to override these methods in
subclasses to provide more specific and appropriate behavior.

Some authors call methods in the UNIVERSAL class on potential invocants as
functions, bypassing any possible overriding.  This is wrong and you should not
do it.  Unfortunately, not everyone heeds this warning and their bad code can
break your good code.

This module replaces C<UNIVERSAL::can()> with a method that checks to see if
the first argument is a valid invocant (whether an object -- a blessed referent
-- or the name of a class).  If so, and if the invocant's class has its own
C<can()> method, it calls that as a method.  Otherwise, everything works as you
might expect.

If someone attempts to call C<UNIVERSAL::can()> as a function, this module will
emit a lexical warning (see L<perllexwarn>) to that effect.  You can disable it
with C<no warnings;> or C<no warnings 'UNIVERSAL::isa';>, but don't do that;
fix the code instead.

Some people argue that you must call C<UNIVERSAL::can()> as a function because
you don't know if your proposed invocant is a valid invocant.  That's silly.
Use C<blessed()> from L<Scalar::Util> if you want to check that the potential
invocant is an object or call the method anyway in an C<eval> block and check
for failure.

Just don't break working code.

=head1 EXPORT

By default, this module exports a C<can()> subroutine that works exactly as
described.  It's a convenient shortcut for you.

=head2 can()

The C<can()> method takes two arguments, a potential invocant and the name of a
method that that invocant may be able to call.  It attempts to divine whether
the invocant is an object or a valid class name, whether there is an overridden
C<can()> method for it, and then calls that.  Otherwise, it calls
C<UNIVERSAL::can()> directly, as if nothing had happened.

=head1 AUTHOR

chromatic, C<< <chromatic@wgz.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-universal-can@rt.cpan.org>,
or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=UNIVERSAL-can>.  This will
contact me, hold onto patches so I don't drop them, and will notify you of
progress on your request as I make changes.

=head1 ACKNOWLEDGEMENTS

Inspired by L<UNIVERSAL::isa> by Yuval Kogman, Autrijus Tang, and myself.

=head1 COPYRIGHT & LICENSE

Copyright (c) 2005 - 2006 chromatic. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
