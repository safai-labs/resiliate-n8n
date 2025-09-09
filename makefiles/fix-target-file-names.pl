#!/usr/bin/perl

$n = $ENV{'PACKAGE_NAME'};
$v = $ENV{'PACKAGE_VERSION'};
while(<>) {
    if (/__pkg_version__(.*?)__pkg_version__/) {
        $_ =~ s/__pkg_version__(.*?)__pkg_version__/__pkg_version__$1$v/g;
    } else {
        $_ =~ s/__pkg_version__/$v/g;
    }
    print;
}
