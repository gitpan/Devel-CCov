package Test;
use strict;
use Carp;
use vars qw($VERSION @ISA @EXPORT $ntest);
$VERSION = "0.01";
require Exporter;
@ISA=('Exporter');
@EXPORT= qw(&declare &ok $ntest);

$|=1;
$^W=1;
$ntext=1;

# Testing for this environment variable is strongly discouraged.
$ENV{REGRESSION_LEVEL} ||= 1;
$ENV{REGRESSION_LEVEL}++;

sub declare {
    croak "declare(%args): odd number of arguments" if @_ & 1;
    my $max=0;
    my $failok=[];
    for (my $x=0; $x < @_; $x+=2) {
	my ($k,$v) = @_[$x,$x+1];
	if ($k eq 'tests') { $max = $v; }
	elsif ($k eq 'failok') { $failok = $v; }
	else { carp "Test::declare(): skipping unrecognized directive '$k'" }
    }
    if (@$failok == 0) {
	print "1..$max\n";
    } else {
	print "1..$max fails ".join(' ', sort { $a<=>$b } @$failok).";\n";
    }
}

sub ok {
    my ($ok, $guess) = @_;
    carp "(this is ok $ntest)" if defined $guess && $guess != $ntest;
    print(($ok? '':'not ')."ok $ntest\n");
    ++ $ntest;
    $ok;
}

# reward non-coredump?
#END { ok(1); }

1;
__END__

=head1 NAME

  Test - provides a simple framework for writing test scripts

=head1 SYNOPSIS

  use strict;
  use Test;
  BEGIN { declare(tests => 15, failok => [3,7]); }

  my $result = "looks good";
  ok($result =~ m/good/) or warn $result;

=head1 DESCRIPTION

Test::Harness expects to see particular output when it executes test
scripts.  This module provides a few handy tools that make conforming
just a little bit easier.

=head1 AUTHOR

Copyright © 1998 Joshua Nathaniel Pritikin.  All rights reserved.

This package is free software and is provided "as is" without express
or implied warranty.  It may be used, redistributed and/or modified
under the terms of the Perl Artistic License (see
http://www.perl.com/perl/misc/Artistic.html)

=cut
