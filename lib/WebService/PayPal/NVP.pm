package WebService::PayPal::NVP;

use Moo;
use LWP::UserAgent ();
use URI::Escape qw/uri_escape uri_unescape/;

our $VERSION = '0.001';

has 'errors' => (
    is => 'rw',
    isa => sub {
        die "errors expects an array reference!\n"
            unless ref $_[0] eq 'ARRAY';
    },
);

has 'user' => ( is => 'rw', required => 1 );
has 'pwd'  => ( is => 'rw', required => 1 );
has 'sig'  => ( is => 'rw', required => 1 );
has 'url'  => ( is => 'rw' );
has 'branch' => ( is => 'rw', default => sub { 'sandbox' } );
has 'api_ver' => ( is => 'rw', default => sub { 51.0 } );

sub BUILDARGS {
    my ($class, %args) = @_;
    # detect URL if it's missing
    if (not $args{url}) {
        $args{url} = "https://api-3t.sandbox.paypal.com/nvp"
            if $args{branch} eq 'sandbox';

        $args{url} = "https://api-3t.paypal.com/nvp"
            if $args{branch} eq 'live';
    }

    return \%args;
}

sub _do_request {
    my ($self, $args) = @_;
    my $lwp = LWP::UserAgent->new;
    $lwp->agent("p-Webservice-PayPal-NVP/${VERSION}");
    
    my $req = HTTP::Request->new(POST => $self->url);
    $req->content_type('application/x-www-form-urlencoded');

    my $authargs = {
        user      => $self->user,
        pwd       => $self->pwd,
        signature => $self->sig,
        version   => $args->{version}||$self->api_ver,
        subject   => $args->{subject}||'',
    };

    my $allargs = { %$authargs, %$args };
    my $content = $self->_build_content( $allargs );
    $req->content($content);
    my $res = $lwp->request($req);

    unless ($res->code == 200) {
        $self->errors(["Failure: " . $res->code . ": " . $res->message]);
        return;
    }

    return { map { uri_unescape($_) }
        map { split '=', $_, 2 }
            split '&', $res->content };
}

sub _build_content {
    my ($self, $args) = @_;
    my @args;
    for my $key (keys %$args) {
        $args->{$key} = defined $args->{$key} ? $args->{$key} : '';
        push @args,
            uc(uri_escape($key)) . '=' . uri_escape($args->{$key});
    }

    return (join '&', @args) || '';
}

sub set_express_checkout {
    my ($self, $args) = @_;
    $args->{method} = 'SetExpressCheckout';
    $self->_do_request( $args );
}

sub do_express_checkout_payment {
    my ($self, $args) = @_;
    $args->{method} = 'DoExpressCheckoutPayment';
    $self->_do_request( $args );
}

=head1 NAME

WebService::PayPal::NVP - PayPal NVP API

=head1 DESCRIPTION

This module is the result of a desperate attempt to save instances of L<Business::PayPal::NVP>. It didn't seem to work inside accessors or Catalyst Adaptors. Although the module worked, this was a major drawback for me. So I re-engineered it using the lovely L<Moo>.

=head1 SYNTAX

my $nvp = WebService::PayPal::NVP->new(
    user   => 'user.tld'
    pwd    => 'xxx',
    sig    => 'xxxxxxx',
    branch => 'sandbox',
);

my $res = $nvp->set_express_checkout({
    DESC              => 'Payment for something cool',
    AMT               => 25.00,
    CURRENCYCODE      => 'GBP',
    PAYMENTACTION     => 'Sale',
    RETURNURL         => "http://returnurl.tld",
    CANCELURL         => 'http//cancelurl.tld",
    LANDINGPAGE       => 'Login',
    ADDOVERRIDE       => 1,
    SHIPTONAME        => "Customer Name",
    SHIPTOSTREET      => "7 Customer Street", 
    SHIPTOSTREET2     => "", 
    SHIPTOCITY        => "Town", 
    SHIPTOZIP         => "Postcode", 
    SHIPTOEMAIL       => "customer\@example.com", 
    SHIPTOCOUNTRYCODE => 'GB',
});

=head1 AUTHOR

Brad Haywood <brad@geeksware.com>

=head1 LICENSE

You may distribute this code under the same terms as Perl itself.

=cut

1;
__END__
