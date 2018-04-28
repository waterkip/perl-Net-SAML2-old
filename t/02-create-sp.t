use lib qw(t/inc);

use Test::Net::SAML2;
use Net::SAML2::SP;

my $sp = Net::SAML2::SP->new(
    id               => 'http://localhost:3000',
    url              => 'http://localhost:3000',
    cert             => 't/sign-nopw-cert.pem',
    cacert           => 't/cacert.pem',
    org_name         => 'Test',
    org_display_name => 'Test',
    org_contact      => 'test@example.com',
);
isa_ok($sp, "Net::SAML2::SP");

my $xpath
    = get_xpath($sp->metadata, md => 'urn:oasis:names:tc:SAML:2.0:metadata');

my @ssos = $xpath->findnodes(
    '//md:EntityDescriptor/md:SPSSODescriptor/md:AssertionConsumerService');

if (is(@ssos, 2, "Got two assertionConsumerService(s)")) {
    is(
        $ssos[0]->getAttribute('Binding'),
        'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST',
        "Returns the correct binding: HTTP-POST"
    );
    is(
        $ssos[1]->getAttribute('Binding'),
        'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Artifact',
        "Returns the correct binding: HTTP-Artifact"
    );
}

done_testing;
