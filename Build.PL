#! perl

use Module::Build;

my $class = Module::Build->subclass(
	class => 'Module::Build::FilterTests',
	code  => <<'END_HERE',
	
	use File::Glob;
	use File::Spec::Functions;
	
	sub ACTION_disttest
	{
		my $self = shift;
		local $ENV{PERL_RUN_ALL_TESTS} = 1;
		$self->SUPER::ACTION_disttest( @_ );
	}
	
	sub find_test_files
	{
		my $self  = shift;
		my $tests = $self->SUPER::find_test_files( @_ );
	    
		return $tests unless $ENV{PERL_RUN_ALL_TESTS};
	
		my $test_pattern = catfile(qw( t developer *.t ) );
		unshift @$tests, File::Glob::bsd_glob( $test_pattern );
		return $tests;
	}
END_HERE
);

my $builder = $class->new(
    module_name         => 'UNIVERSAL::can',
    license             => 'perl',
    dist_author         => 'chromatic <chromatic@wgz.org>',
    dist_version_from   => 'lib/UNIVERSAL/can.pm',
	requires            =>
	{
		'perl'          => '5.6.0',
		'Scalar::Util'  => '',
	},
    build_requires      =>
	{
        'Test::Simple'  => '0.60',
    },
    add_to_cleanup      => [ 'UNIVERSAL-can-*' ],
	create_makefile_pl  => 'traditional',
	sign                => 1,
);

$builder->create_build_script();
