package Redis::Interface::Client::Add;
use Moose::Role;
use Carp;

sub add {
    my $self = shift;
    my ($key, $value, $expiration_time) = @_;

    if ( not defined($expiration_time) ) {
        $expiration_time = $self->expiration_time();
    }
    my $o = $self->_accessor();

    if (ref($value) eq q(ARRAY)) {
        if(not $o->exists($key)){
                foreach my $element (@$value){
                        $o->rpush($key,$element);
                }
                return $o->expire($key, $expiration_time);
        }
    } elsif (ref($value) eq q(HASH)) {
        if(not $o->exists($key)){
                foreach my $element (keys %$value){
                        $o->hset($key,$element,$value->{$element});
                }
                return $o->expire($key, $expiration_time);
        }
    } else{
        $o->setnx($key,$value);
        return $o->expire($key,$expiration_time);
    }
}
1;
