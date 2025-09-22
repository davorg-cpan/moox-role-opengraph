package MooX::Role::OpenGraph;

=head1 NAME

MooX::Role::OpenGraph - A role for generating OpenGraph meta tags

=head1 SYNOPSIS

  package MyWebPage;
  use Moo;
  with 'MooX::Role::OpenGraph';

  has 'og_title' => (is => 'ro', required => 1);
  has 'og_type'  => (is => 'ro', required => 1);
  has 'og_url'   => (is => 'ro', required => 1);
  has 'og_image' => (is => 'ro'); # optional

  # And later, in the code that builds the website

  my $page = MyWebPage->new(
    og_title       => "My Page Title",
    og_type        => "website",
    og_description => 'This is a lovely websote',
    og_url         => "https://example.com/my-page",
    og_image       => "https://example.com/image.jpg",
  );

  # Print tags separately

  print $page->title_tag;
  print $page->canonical_tag;
  print $page->og_tags;

  # Or print all tags at once
  print $page->tags;

=head1 DESCRIPTION

This role provides methods to generate OpenGraph meta tags for web pages. It
requires the consuming class to implement the following attributes or methods:

=over 4

=item * og_title - The title of the page

=item * og_type - The type of the page (e.g., "website", "article")

=item * og_url - The canonical URL of the page

=item * og_image - The URL of an image representing the content (optional)

=back

The role provides methods to generate individual tags as well as a method to
generate all tags at once.

=head1 METHODS

=head2 title_tag

Returns the HTML title tag.

=head2 canonical_tag

Returns the HTML canonical link tag.

=head2 description_tag

Returns the HTML meta description tag.

=head2 og_title_tag

Returns the OpenGraph title meta tag.

=head2 og_type_tag

Returns the OpenGraph type meta tag.

=head2 og_description_tag

Returns the OpenGraph description meta tag.

=head2 og_url_tag

Returns the OpenGraph URL meta tag.

=head2 og_image_tag

Returns the OpenGraph image meta tag if the og_image attribute is provided.

=head2 og_tags

Returns all OpenGraph meta tags as a single string.

=head2 twitter_card_tag

Returns the Twitter card meta tag.

=head2 twitter_title_tag

Returns the Twitter title meta tag.

=head2 twitter_description_tag

Returns the Twitter description meta tag.

=head2 twitter_image_tag

Returns the Twitter image meta tag if the og_image attribute is provided.

=head2 twitter_tags

Returns all Twitter meta tags as a single string.

=head2 tags

Returns all tags (title, canonical, and OpenGraph) as a single string.

=cut

use feature qw[signatures];

use Moo::Role;

our $VERSION = '0.0.4';

requires qw[og_title og_type og_description og_url];

sub title_tag($self) {
  return sprintf '<title>%s</title>', $self->og_title;
}

sub canonical_tag($self) {
  return sprintf '<link rel="canonical" href="%s">', $self->og_url;
}

sub description_tag($self) {
  return sprintf '<meta name="description" content="%s">', $self->og_description;
}

sub og_title_tag($self) {
  return sprintf '<meta property="og:title" content="%s">', $self->og_title;
}

sub og_type_tag($self) {
  return sprintf '<meta property="og:type" content="%s">', $self->og_type;
}

sub og_description_tag($self) {
  return sprintf '<meta property="og:description" content="%s">',
                 $self->og_description;
}

sub og_url_tag($self) {
  return sprintf '<meta property="og:url" content="%s">', $self->og_url;
}

sub og_image_tag($self) {
  return '' unless $self->can('og_image');
  return sprintf '<meta property="og:image" content="%s">', $self->og_image;
}

sub og_tags($self) {
  return join "\n", $self->og_title_tag,
                    $self->og_type_tag,
                    $self->og_description_tag,
                    $self->og_url_tag,
                   ($self->og_image_tag || ());
}

sub twitter_card_tag($self) {
  my $card_type;
  if ($self->can('twitter_card_type')) {
    $card_type = $self->twitter_card_type;
  }
  else {
    $card_type = $self->can('og_image') ? 'summary_large_image' : 'summary';
  }
  return qq[<meta name="twitter:card" content="$card_type">];
}

sub twitter_title_tag($self) {
  return sprintf '<meta name="twitter:title" content="%s">', $self->og_title;
}

sub twitter_description_tag($self) {
  return sprintf '<meta name="twitter:description" content="%s">', $self->og_description;
}

sub twitter_image_tag($self) {
  return unless $self->can('og_image');
  return sprintf '<meta name="twitter:image" content="%s">', $self->og_image;
}

sub twitter_tags($self) {
  return join "\n", $self->twitter_card_tag,
                    $self->twitter_title_tag,
                    $self->twitter_description_tag,
                   ($self->twitter_image_tag || ());
}

sub tags($self) {
  return join "\n", $self->title_tag,
                    $self->description_tag,
                    $self->canonical_tag,
                    $self->og_tags,
                    $self->twitter_tags;
}

1;

=head1 AUTHOR

Dave Cross <dave@perlhacks.com>

=head1 COPYRIGHT

Copyright (c) 2025 Magnum Solutions Ltd. This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

=cut
