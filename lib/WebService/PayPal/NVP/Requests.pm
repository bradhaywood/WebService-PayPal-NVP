package WebService::PayPal::NVP::Requests;

use Moo::Role;
our $VERSION = '0.001';

sub set_express_checkout {
    my ($self, $args) = @_;
    $args->{method} = 'SetExpressCheckout';
    $self->_do_request($args);
}

sub do_express_checkout_payment {
    my ($self, $args) = @_;
    $args->{method} = 'DoExpressCheckoutPayment';
    $self->_do_request($args);
}

sub get_express_checkout_details {
    my ($self, $args) = @_;
    $args->{method} = 'GetExpressCheckoutDetails';
    $self->_do_request($args);
}

sub do_direct_payment {
    my ($self, $args) = @_;
    $args->{method} = 'DoDirectPayment';
    $self->_do_request($args);
}

sub create_recurring_payments_profile {
    my ($self, $args) = @_;
    $args->{method} = 'CreateRecurringPaymentsProfile';
    $self->_do_request($args);
}

sub manage_recurring_payments_profile_status {
    my ($self, $args) = @_;
    $args->{method} = 'ManageRecurringPaymentsProfileStatus';
    $self->_do_request($args);
}

sub mass_pay {
    my ($self, $args) = @_;
    $args->{method} = 'MassPay';
    $self->_do_request($args);
}

sub refund_transaction {
    my ($self, $args) = @_;
    $args->{method} = 'RefundTransaction';
    $self->_do_request($args);
}

=head1 NAME

WebService::PayPal::NVP::Requests - The PayPal methods for WebService::PayPal::NVP

=head1 DESCRIPTION

This is a Moo role containing all of the methods used to contact the PayPal NVP API. L<WebService::PayPal::NVP> consumes this.

=head2 create_recurring_payments_profile( $HashRef )

=head2 do_direct_payment( $HashRef )

=head2 do_express_checkout_payment( $HashRef )

=head2 get_express_checkout_details( $HashRef )

=head2 manage_recurring_payments_profile_status( $HashRef )

=head2 mass_pay( $HashRef )

=head2 refund_transaction( $HashRef )

=head2 set_express_checkout( $HashRef )

=cut

1;
__END__