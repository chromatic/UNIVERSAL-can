#! perl

BEGIN { require 5.006002 }

use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'UNIVERSAL::can',
    license             => 'perl',
    dist_author         => 'chromatic <chromatic@wgz.org>',
    dist_version_from   => 'lib/UNIVERSAL/can.pm',
    requires            =>
    {
        'perl'          => '5.6.2',
        'Scalar::Util'  => '',
        'Test::Simple'  => '0.60',
    },
    build_requires      =>
    {
        'Test::Simple'  => '0.60',
    },
    config_requires     =>
    {
        'Module::Build' => '0.33',
    },
    add_to_cleanup      => [ 'UNIVERSAL-can-*' ],
);

$builder->create_build_script();
