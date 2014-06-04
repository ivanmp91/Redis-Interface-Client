package Redis::Interface::Client::Set;
use Moose::Role;
use Carp;

sub set {
    my $self = shift;
    my ($key, $value, $expiration_time) = @_;
    my $o = $self->_accessor();

    if ( not defined($expiration_time) ) {
        $expiration_time = $self->expiration_time();
    }

    if (ref($value) eq q(ARRAY)) {
        if($o->exists($key)){
                if($o->type($key) eq q(list)){
                        my $list_length = $o->llen($key);
                        $o->del($key) if $list_length > 0;
                } else{
                        $o->del($key);
                }
        }
        foreach my $element (@$value){
                $o->rpush($key,$element);
        }
        return $o->pexpire($key, $expiration_time);
    } elsif(ref($value) eq q(HASH)){
        if($o->exists($key)){
                if($o->type($key) eq q(hash)){
                        my $hash_length = $o->hlen($key);
                        $o->del($key) if $hash_length > 0;
                } else{
                        $o->del($key);
                }
        }
	foreach my $element (keys %$value){
                $o->hset($key,$element,$value->{$element});
        }
        return $o->expire($key, $expiration_time);
    } else{
        return $o->setex($key, $expiration_time, $value);
    }
}
1;
