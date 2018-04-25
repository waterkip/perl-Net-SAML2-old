use strict;
use warnings;

use Test::Most;
use Net::SAML2;

my $sp = Net::SAML2::SP->new(
    cacert           => 't/cacert.pem',
    cert             => 't/sign-nopw-cert.pem',
    id               => 'http://localhost:3000',
    key              => 't/sign-nopw-cert.pem',
    org_contact      => 'test@example.com',
    org_display_name => 'Test',
    org_name         => 'Test',
    url              => 'http://localhost:3000',
);
isa_ok($sp, "Net::SAML2::SP");

my $xml = $sp->metadata;
isa_ok($xml, "XML::Generator::pretty");

my $xpath = XML::XPath->new(xml => $xml);
$xpath->set_namespace('md', 'urn:oasis:names:tc:SAML:2.0:metadata');

my @ssos = $xpath->findnodes('//md:EntityDescriptor/md:SPSSODescriptor/md:AssertionConsumerService');

if (is(@ssos, 2, "Got two assertionConsumerService(s)")) {
    is($ssos[0]->getAttribute('Binding'), 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST', "Returns the correct binding: HTTP-POST");
    is($ssos[1]->getAttribute('Binding'), 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Artifact', "Returns the correct binding: HTTP-Artifact");
}

done_testing;
