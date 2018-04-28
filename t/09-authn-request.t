use lib qw(t/inc);
use Test::Net::SAML2;

use Net::SAML2::Protocol::AuthnRequest;

my $ar = Net::SAML2::Protocol::AuthnRequest->new(
    issuer        => 'http://some/sp',
    destination   => 'http://some/idp',
    nameid_format => 'urn:oasis:names:tc:SAML:2.0:nameid-format:persistent',
);

isa_ok($ar, "Net::SAML2::Protocol::AuthnRequest");

my $override
    = Sub::Override->override(
    'Net::SAML2::Protocol::AuthnRequest::issue_instant' =>
        sub { return 'myissueinstant' });

$override->override(
    'Net::SAML2::Protocol::AuthnRequest::id' => sub { return 'myid' });

my $xml = $ar->as_xml;

my $xp = get_xpath(
    $xml,
    samlp => 'urn:oasis:names:tc:SAML:2.0:protocol',
    saml  => 'urn:oasis:names:tc:SAML:2.0:assertion',
);

test_xml_attribute_ok($xp, '/samlp:AuthnRequest/@ID', 'myid');
test_xml_attribute_ok($xp, '/samlp:AuthnRequest/@IssueInstant',
    'myissueinstant');
test_xml_attribute_ok(
    $xp,
    '/samlp:AuthnRequest/samlp:NameIDPolicy/@Format',
    'urn:oasis:names:tc:SAML:2.0:nameid-format:persistent'
);
test_xml_attribute_ok($xp,
    '/samlp:AuthnRequest/samlp:NameIDPolicy/@AllowCreate', '1');

done_testing;
