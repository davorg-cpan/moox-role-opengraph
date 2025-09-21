use Test::More;

use lib 't/lib';

use Object;

my $obj = Object->new({
  title => 'title',
  type => 'object',
  url => 'https://example.com/object/',
  image => 'https://example.com/object.png',
});

ok $obj;

diag $obj->tags;

done_testing;
