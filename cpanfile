requires "Carp" => "0";
requires "Class::Accessor" => "0";
requires "Crypt::OpenSSL::DSA" => "0";
requires "Crypt::OpenSSL::RSA" => "0";
requires "Crypt::OpenSSL::Random" => "0";
requires "Crypt::OpenSSL::VerifyX509" => "0";
requires "Crypt::OpenSSL::X509" => "0";
requires "DateTime" => "0";
requires "DateTime::Format::XSD" => "0";
requires "Digest::SHA" => "0";
requires "Digest::SHA1" => "0";
requires "Exporter" => "0";
requires "Path::Tiny" => "0";
requires "File::Slurp" => "0";
requires "HTTP::Request::Common" => "0";
requires "IO::Compress::RawDeflate" => "0";
requires "IO::Uncompress::RawInflate" => "0";
requires "LWP::UserAgent" => "0";
requires "MIME::Base64" => "0";
requires "Moose" => "0";
requires "Moose::Role" => "0";
requires "MooseX::Types::Common::String" => "0";
requires "MooseX::Types::DateTime" => "0";
requires "MooseX::Types::Moose" => "0";
requires "MooseX::Types::URI" => "0";
requires "URI" => "0";
requires "URI::QueryParam" => "0";
requires "XML::CanonicalizeXML" => "0";
requires "XML::Generator" => "0";
requires "XML::XPath" => "0";
requires "base" => "0";
requires "constant" => "0";
requires "perl" => "5.013010";
requires "strict" => "0";
requires "vars" => "0";
requires "warnings" => "0";

# Breaks the build on docker
# TODO: https://gitlab.com/waterkip/perl-net-saml2/issues/2
recommends "XML::Canonical" => "0";

on 'test' => sub {
  requires "Path::Tiny" => "0";
  requires "Sub::Override" => "0";
  requires "File::Spec" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "Test::Mock::One" => "0";
  requires "Test::More" => "0";
  requires "Test::Most" => "0";
  requires "Test::NoTabs" => "0";
  requires "Test::Pod" => "1.14";
  requires "Import::Into" => "0";
  requires "XML::LibXML::XPathContext" => "0";
  requires "XML::LibXML" => "0";
  requires "Test::Pod::Coverage" => "1.04";
  requires "perl" => "5.013010";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "perl" => "5.013010";
};

on 'develop' => sub {
  requires "Dist::Zilla" => "5";
  requires "Dist::Zilla::Plugin::BumpVersionAfterRelease::Transitional" => "0.004";
  requires "Dist::Zilla::Plugin::CopyFilesFromRelease" => "0";
  requires "Dist::Zilla::Plugin::Git::Commit" => "2.020";
  requires "Dist::Zilla::Plugin::Git::Tag" => "0";
  requires "Dist::Zilla::Plugin::NextRelease" => "5.033";
  requires "Dist::Zilla::Plugin::RewriteVersion::Transitional" => "0.004";
  requires "Dist::Zilla::PluginBundle::Author::WATERKIP" => "0";
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Software::License::Perl_5" => "0";
  requires "Test::CPAN::Changes" => "0.19";
  requires "Test::CPAN::Meta" => "0";
  requires "Test::CPAN::Meta::JSON" => "0.16";
  requires "Test::EOL" => "0";
  requires "Test::Kwalitee" => "1.21";
  requires "Test::MinimumVersion" => "0";
  requires "Test::Mojibake" => "0";
  requires "Test::More" => "0.96";
  requires "Test::NoTabs" => "0";
  requires "Test::Perl::Critic" => "0";
  requires "Test::Pod" => "1.41";
  requires "Test::Pod::Coverage" => "1.08";
  requires "Test::Pod::LinkCheck" => "0";
  requires "Test::Portability::Files" => "0";
  requires "Test::Synopsis" => "0";
  requires "Test::Vars" => "0";
  requires "Test::Version" => "1";
};
