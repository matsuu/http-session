use strict;
use warnings;
use Test::More;
use Test::Exception;
use HTTP::Session;
use CGI;
use HTTP::Session::State::Null;

plan skip_all => "this test requires CHI" unless eval "use CHI; 1;";
plan tests => 4*2;
require HTTP::Session::Store::CHI;

run_tests(
    HTTP::Session::Store::CHI->new(
        chi => CHI->new(driver => 'Memory'),
        expires => 60*60,
    )
);
run_tests(
    HTTP::Session::Store::CHI->new(
        chi => +{ driver => 'Memory' },
        expires => 60*60,
    )
);

sub run_tests {
    my $store = shift;
    $store->insert('foo' => 'bar');
    is $store->select('foo'), 'bar';
    $store->update('foo' => 'baz');
    is $store->select('foo'), 'baz';
    $store->delete('foo' => 'baz');
    is $store->select('foo'), undef;
    $store->insert('foo' => {boo => 'fy'});
    is $store->select('foo')->{'boo'}, 'fy', 'complex';
}
