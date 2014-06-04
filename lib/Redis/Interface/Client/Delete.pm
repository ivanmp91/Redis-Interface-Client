package Redis::Interface::Client::Delete;
use Moose::Role;
use Carp;

sub delete {
    my $self = shift;

    my $o = $self->_accessor();
    return $o->del(@_);
}
1;
