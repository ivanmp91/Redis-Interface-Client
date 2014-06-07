use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Redis::Interface::Client',
    AUTHOR           => q{Ivan Mora Perez <ivan@opentodo.net>},
    VERSION_FROM     => 'lib/Redis/Interface/Client.pm',
    ABSTRACT_FROM    => 'lib/Redis/Interface/Client.pm',
    LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'Redis' => 1.974,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Redis-Interface-Client-*' },
);
