package Data::Polipo;

use 5.008009;
use strict;
use warnings;

use IO::File;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Data::Polipo ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';


# Preloaded methods go here.

our $count = 0;

sub new {
    my ($class, $file) = @_;
    my $h = {};

    my $fh = new IO::File $file, "r" or die "$file: $!";
    local $/ = "\r\n";
    my $res = <$fh>;
    chomp $res;

    my $ns = $class . "::" . $count ++;

    while (my $line = <$fh>) {
	chomp $line;
	last if ($line =~ /^$/);

	my ($k, $v) = $line =~ /([^:]+):\s*(.*)/;
	warn $line and next unless ($k);
	$k =~ s/-/_/g;
	$k =~ s/^(.+)$/\L$1\E/;
	if (! defined $h->{$k}) {
	    $h->{$k} = $v;
	    no strict 'refs';
	    *{$ns . "::" . $k} = (sub {my $v=shift; sub {$v}})->($v);
	}
    }

    if (my $offset = $h->{x_polipo_body_offset}) {
	$fh->seek ($offset, SEEK_SET);
    }

    my $d = bless {} => $ns;
    my $obj = sub {wantarray ? ($fh, $res) : $d};
    bless $obj => $class;
}

sub open {
    return ($_[0]->())[0];
}

sub status {
    return ($_[0]->())[1];
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Data::Polipo - Perl extension for Polipo cache file

=head1 SYNOPSIS

  use Data::Polipo;
  my $p = new Data::Polipo ("t/o3kvmCJ-O2CcW2TH2KebbA==");
  $p->status;			# Return status
  $p->()->content_type;		# Content-Type
  my $fh = $p->open;		# File handle

=head1 DESCRIPTION

Stub documentation for Data::Polipo, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Toru Hisai, E<lt>toru@localE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Toru Hisai

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.9 or,
at your option, any later version of Perl 5 you may have available.


=cut
