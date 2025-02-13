use lib qw(t/inc);
use Test::Net::SAML2;

use Net::SAML2::SP;
use Net::SAML2::IdP;

use LWP::UserAgent;

my $override = override_verify_x509_verify(1);

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

my $metadata = path('t/idp-metadata.xml')->slurp;

my $idp = Net::SAML2::IdP->new_from_xml(
    xml    => $metadata,
    cacert => 't/cacert.pem'
);
isa_ok($idp, "Net::SAML2::IdP");

my $slo_url = $idp->slo_url($idp->binding('soap'));
is(
    $slo_url,
    'http://sso.dev.venda.com/opensso/IDPSloSoap/metaAlias/idp',
    'SLO url is correct'
);

my $idp_cert = $idp->cert('signing');
like($idp_cert, qr/-----BEGIN CERTIFICATE-----/, "Looks like a certificate");

my $nameid  = 'user-to-log-out';
my $session = 'session-to-log-out';

my $request
    = $sp->logout_request($idp->entityid, $nameid, $idp->format('persistent'),
    $session);

isa_ok($request, "Net::SAML2::Protocol::LogoutRequest");
my $request_xml = $request->as_xml;

my $xp = get_xpath($request_xml);
isa_ok($xp, "XML::LibXML::XPathContext");

my $ua = LWP::UserAgent->new;
my $soap = $sp->soap_binding($ua, $slo_url, $idp_cert);
isa_ok($soap, "Net::SAML2::Binding::SOAP");

my $soap_req = $soap->create_soap_envelope($request_xml);

# TODO: set soap paths and check envelop and body
$xp = get_xpath($soap_req);
isa_ok($xp, "XML::LibXML::XPathContext");

my ($subject, $xml) = $soap->handle_request($soap_req);
is(
    $subject,
    'C=US, O=local, OU=ct, CN=saml, emailAddress=saml@ct.local',
    "Subject is ok"
);
like($xml, qr/\Q<samlp:LogoutRequest\E/, "Logout XML found");
$xp = get_xpath($xml);
isa_ok($xp, "XML::LibXML::XPathContext");

my $soaped_request = Net::SAML2::Protocol::LogoutRequest->new_from_xml(
    xml => $xml
);
isa_ok($soaped_request, 'Net::SAML2::Protocol::LogoutRequest');

is($soaped_request->session, $request->session,
    "SOAP session equals request session");
is($soaped_request->nameid, $request->nameid,
    "SOAP nameid equals request nameid");

done_testing;
