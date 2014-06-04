package Redis::Interface::Client::Replace;
use Moose::Role;
use Carp;

sub replace {
    my $self = shift;
    my ($key, $value, $expiration_time) = @_;

    if ( not defined($expiration_time) ) {
        $expiration_time = $self->expiration_time();
    }
    my $o = $self->_accessor();
    if (ref($value) eq q(ARRAY)) {
         if($o->exists($key)){
              $o->del($key);
              foreach my $element (@$value){
                  $o->rpush($key,$element);
              }
              return $o->expire($key, $expiration_time);
          }
    } elsif (ref($value) eq q(HASH)) {
         if($o->exists($key)){
              $o->del($key);
              foreach my $element (keys %$value){
                  $o->hset($key,$element,$value->{$element});
              }
              return $o->expire($key, $expiration_time);
          }
    } else{
         if($o->exists($key)){
                return $o->setex($key,$expiration_time,$value);
         }
    }
}
1;
