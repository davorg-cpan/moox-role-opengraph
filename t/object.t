use Test::More;

use lib 't/lib';

use Object;

my $obj = Object->new({
  title => 'title',
  type => 'object',
  desc => 'description of the object',
  url => 'https://example.com/object/',
  image => 'https://example.com/object.png',
});

ok $obj;

my @tests = ({
  method => 'title_tag',
  text   => '<title>title</title>',
}, {
  method => 'canonical_tag',
  text   => '<link rel="canonical" href="https://example.com/object/">',
}, {
  method => 'og_title_tag',
  text   => '<meta property="og:title" content="title">',
}, {
  method => 'og_type_tag',
  text   => '<meta property="og:type" content="object">'
}, {
  method => 'twitter_card_tag',
  text   => '<meta name="twitter:card" content="summary_large_image">',
}, {
  method => 'twitter_title_tag',
  text   => '<meta name="twitter:title" content="title">',
});

for (@tests) {
  my $method = $_->{method};
  is $obj->$method, $_->{text}, "Calling $method is correct";
}

diag $obj->tags;

done_testing;
