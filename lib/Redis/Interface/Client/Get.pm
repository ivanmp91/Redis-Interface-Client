package Redis::Interface::Client::Get;
use Moose::Role;
use Carp;

sub get {
    my $self = shift;
    my $key = shift;

    carp(">> called Redis::Interface::Client::Get ". scalar(@_). " arg(s): ".
         join(',' => map { ">".$_."<"} ($key)). "\n") if ($self->debug_mode());

    my $o = $self->_accessor();
    my $type = $o->type($key);
    if($type eq q(list)){
        my $list_length = $o->llen($key);
        my @list = $o->lrange($key, 0, $list_length);
        return @list;

    } elsif($type eq q(hash)){
        my @keys = $o->hkeys($key);
        my %hash;
        foreach(@keys){
                my $k = $_;
                $hash{$k} = $o->hget($key,$k);
        }
        return %hash;
    }else{
        return $o->get($key);
    }
    return ();
}
1;
