package Redis::Interface::Client::Append;
use Moose::Role;
use Carp;

sub append {
    my $self = shift;
    my ($key, $value, $expiration_time) = @_;

    if ( not defined($expiration_time) ) {
        $expiration_time = $self->expiration_time();
    }
    my $o = $self->_accessor();

    if (ref($value) eq q(ARRAY)) {
        if($o->exists($key)){
                foreach my $element (@$value){
                        $o->rpush($key,$element);
                }
                return $o->expire($key, $expiration_time);
        }
    } elsif (ref($value) eq q(HASH)) {
        if($o->exists($key)){
                foreach my $element (keys %$value){
                        $o->hset($key,$element,$value->{$element});
                }
                return $o->expire($key, $expiration_time);
        }
    } else{
        $o->append($key,$value);
        return $o->expire($key,$expiration_time);
    }
}
1;
