use lib qw(t/inc);
use Test::Net::SAML2;

use Net::SAML2::SP;
use Net::SAML2::IdP;

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
ok($sp);

my $metadata = path('t/idp-metadata.xml')->slurp;

my $idp = Net::SAML2::IdP->new_from_xml(
    xml    => $metadata,
    cacert => 't/cacert.pem'
);

isa_ok($idp, "Net::SAML2::IdP");

my $sso_url = $idp->sso_url($idp->binding('redirect'));
is(
    $sso_url,
    'http://sso.dev.venda.com/opensso/SSORedirect/metaAlias/idp',
    'Redirect URI is correct'
);

my $authnreq = $sp->authn_request(
    $idp->entityid,
    $idp->format('persistent')
)->as_xml;

my $xp = get_xpath($authnreq);
# TODO: Check if certain things exist

my $redirect = $sp->sso_redirect_binding($idp, 'SAMLRequest');
isa_ok($redirect, 'Net::SAML2::Binding::Redirect');

my $location = $redirect->sign($authnreq, 'http://return/url');

# TODO: Use URI to grab the base URI and query params to check if
# everything exists

like(
    $location,
    qr#\Qhttp://sso.dev.venda.com/opensso/SSORedirect/metaAlias/idp?SAMLRequest=\E#,
    "location checks out"
);

my ($request, $relaystate) = $redirect->verify($location);

# TODO: improve request qr/typy things
like($request, qr/samlp:AuthnRequest/, "Auth request looks ok");

is($relaystate, 'http://return/url', "Relay state shows correct uri");

done_testing;
