package Redis::Interface::Client;

use 5.006;
use strict;
use warnings FATAL => 'all';
use Redis;
use Carp;
use Moose;

with qw{Redis::Interface::Client::Get Redis::Interface::Client::Set Redis::Interface::Client::Delete Redis::Interface::Client::Replace Redis::Interface::Client::Add Redis::Interface::Client::Append};


=head1 NAME

Redis::Interface::Client

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

  use Redis::Interface::Client;

  my $cache = Redis::Interface::Client->new(server=>"redis1:6379");

  $cache->set($key, $value);
  $cache->set($key, \@array_of_values);
  $cache->set($key, $value [, $expiration_time]);

  my @results = $cache->get($key);


=head1 ATTRIBUTES

=head2 debug_mode
rw, boolean, default=0; This attribute enable/disable debug output messages
generated from the module itself and from Redis module.
=cut

has debug_mode => (
                   is           =>'rw',
                   isa          => 'Bool',
                   default      => 0
                 );

=head2 server
rw, String, default=undef; server definition for a redis server: <HOSTNAME:PORT>
=cut

has server => (
                is      => 'rw',
                isa     => 'Str',
                default => ''
);

=head2 sentinels
rw, String, default=undef; Array reference with a list of sentinel servers
=cut

has sentinels => (
	is 	=> 'rw',
	isa 	=> 'ArrayRef[Str]',
	default	=> undef
);

=head2 service
rw, String, default=undef; Service name to use with sentinel
=cut

has service => (
        is      => 'rw',
        isa     => 'Str',
        default => ''
);

=head2 _accessor
Contains a redis object.
=cut

has _accessor => (
                   is           => 'rw',
                   isa          => 'Object',
                   init_arg     => undef
                  );

=head2 expiration_time
rw, integer, default=24*60*60; this is the default expiration time
when the I<set> method is called without an explicit expiration time
argument.
=cut

has expiration_time => (
                        is      => 'rw',
                        isa     => 'Int',
                        default => sub { 60*60*24 }
                       );


=head1 METHODS
Methods should behave as the originals in Redis, please
consult the documentation for that module.

There are some changes on the behaviour of some functions like: the I<get> and I<set> methods, and the
related I<add> and I<replace> methods.
=cut

=head2 BUILD
Constructor of the class to initialize the Redis object
=cut

sub BUILD
{
    my $self = shift;
    my $object;
    if(defined($self->sentinels) && defined($self->service)){
        $object = Redis->new(sentinels => $self->sentinels, service => $self->service , debug => $self->debug_mode);	
    } else{
        $object = Redis->new(server => $self->server, debug => $self->debug_mode);
    }
    $self->_accessor($object);
}

=head2 disconnect
Method to disconnect from the server
=cut

sub disconnect
{
    my $self = shift;

    my $o = $self->_accessor();
    return $o->quit();
}

=over 7

=item I<set>

This method behaves as I<set> in I<Redis>, except that it
can be given a reference to an array or hash as its $value. 

=back

=over 7

=item I<get>

This method behaves as I<get> in I<Redis>, except it can return
a hash or array depending on the data type stored on one key.
method.

=back
=over 7

=item I<add>

Same as set, but only stores a key on redis if not exists.

=back

=over 7

=item I<replace>

Same as set, but overwrites the key on redis. Doesn't write on redis if not exists.

=back

=over 7

=item I<append>

Append the value of a key with the value passed, valid for hashes, strings or arrays. 
If the key doesn't exists the method will not create it.

=back

=over 7

=item I<delete>

Has the same behaviour as I<Redis> del function, deletes a key from redis.

=back


=head1 AUTHOR

Ivan Mora Perez, C<< <ivan at opentodo.net> >>

=head1 SEE ALSO

http://search.cpan.org/dist/Redis/lib/Redis.pm
http://redis.io/commands

=head1 LICENSE AND COPYRIGHT

Copyright 2014 Ivan Mora Perez.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of Redis::Interface::Client
