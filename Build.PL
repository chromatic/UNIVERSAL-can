use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'UNIVERSAL::can',
    license             => 'perl',
    dist_author         => 'chromatic <chromatic@wgz.org>',
    dist_version_from   => 'lib/UNIVERSAL/can.pm',
	requires            =>
	{
		'Scalar::Util'  => '',
	},
    build_requires      =>
	{
        'Test::Simple'  => '0.60',
		'Test::Warn'    => '0.08',
    },
    add_to_cleanup      => [ 'UNIVERSAL-can-*' ],
	create_makefile_pl  => 'traditional',
	sign                => 1,
);

$builder->create_build_script();
