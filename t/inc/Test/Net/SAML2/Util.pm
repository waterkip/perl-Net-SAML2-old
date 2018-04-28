package Test::Net::SAML2::Util;
use warnings;
use strict;

# ABSTRACT: Utils for testsuite of Net::SAML2

require Exporter;
our @ISA    = qw(Exporter);
our @EXPORT = qw(
    get_xpath
    override
    override_verify_x509_verify
    test_xml_attribute_ok
    test_xml_value_ok
 );

our @EXPORT_OK;

our %EXPORT_TAGS = (
    all => [@EXPORT, @EXPORT_OK],
);

use XML::LibXML::XPathContext;
use XML::LibXML;
use Sub::Override;
use Test::More;

sub get_xpath {
    my ($xml, %ns) = @_;

    my $xp = XML::LibXML::XPathContext->new(
        XML::LibXML->load_xml(string => $xml)
    );

    $xp->registerNs($_, $ns{$_}) foreach keys %ns;

    return $xp;
}

sub test_xml_attribute_ok {
    my ($xpath, $search, $value) = @_;

    my @nodes = $xpath->findnodes($search);
    if (is(@nodes, 1, "$search returned one node")) {
        return is($nodes[0]->getValue, $value, ".. and has value '$value'");
    }
    return 0;
}

sub test_xml_value_ok {
    my ($xpath, $search, $value) = @_;

    my @nodes = $xpath->findnodes($search);
    if (is(@nodes, 1, "$search returned one node")) {
        return is($nodes[0]->textContent, $value, ".. and has value '$value'");
    }
    return 0;
}

sub override {
  return Sub::Override->override(@_);
}

# On debian testing we have an issue with an underlying module. For one
# reason or another I have the module installed, but it breaks on
# reinstallation. So we mock the module
#
# TODO: https://gitlab.com/waterkip/perl-net-saml2/issues/1
sub override_verify_x509_verify {
  my $override = shift // 1;

  return override('Crypt::OpenSSL::VerifyX509::verify' => sub {
        return 1;
    }
  );
}

1;

__END__

=head1 DESCRIPTION

=head1 SYNOPSIS

    use Test::Net::SAML2::XML;

    my $xpath = get_xpath($xml);
    # go from here
