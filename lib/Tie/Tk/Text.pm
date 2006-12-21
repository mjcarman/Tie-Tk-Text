#===============================================================================
# Tie/Tk/Text.pm
# Last Modified: 11/19/2006 2:25PM
#===============================================================================
package Tie::Tk::Text;
use strict;

use vars qw'$VERSION';
$VERSION = '0.01';

#-------------------------------------------------------------------------------
# Method  : TIEARRAY
# Purpose : Tie an array to a Text widget.
# Notes   : 
#-------------------------------------------------------------------------------
sub TIEARRAY {
	my $class  = shift;
	my $widget = shift;

	return bless \$widget, $class;
}

#-------------------------------------------------------------------------------
# Method  : FETCH
# Purpose : Retrieve a line of text from a Text widget.
# Notes   : Text widgets use 1-based indexing for line numbers
#-------------------------------------------------------------------------------
sub FETCH {
	my $self = shift;
	my $line = shift() + 1;

	return $$self->get("$line.0", "$line.end + 1 chars");
}

#-------------------------------------------------------------------------------
# Method  : FETCHSIZE
# Purpose : Retrieve the number of lines in Text widget
# Notes   : Text widgets use 1-based indexing for line numbers
#-------------------------------------------------------------------------------
sub FETCHSIZE {
	my $self = shift;
	my ($line, $char) = split(/\./, $$self->index('end'));

	# we need to account for the last line containing a newline, but I'm 
	# not sure why we need to look back two chars instead of one.
	my $lc = $$self->get('end - 2 chars');
	return $lc eq "\n" ? $line - 2 : $line - 1;
}

#sub STORE     {}
#sub STORESIZE {}
#sub EXTEND    {}
#sub EXISTS    {}
#sub DELETE    {}
#sub CLEAR     {}
#sub PUSH      {}
#sub POP       {}
#sub SHIFT     {}
#sub UNSHIFT   {}
#sub SPLICE    {}

1;

__END__

=pod

=head1 NAME

Tie::Tk::Text - Access Tk::Text or Tk::ROText widgets as arrays.

=head1 SYNOPSIS

  use Tie::Tk::Text;

  my $w = $mw->Text()->pack();
  tie my @text, 'Tie::Tk::Text', $w;

  $w->insert('end', "foo\nbar\nbaz\n");
  
  print $text[1]; # "bar\n"

=head1 DESCRIPTION

This module defines a class for tie()ing Tk::Text and Tk::ROText widgets to an
array, allowing them to be accessed as if they were an array of lines.

It's not expected that anyone will actually want to populate their Text widgets
this way. Instead, this makes them accessible to functions which expect an
array reference as their input. (e.g. Algorithm::Diff::sdiff)

=head1 BUGS

Only provides read support at present. (i.e. FETCH and FETCHSIZE)

=head1 AUTHOR

Michael J. Carman <mjcarman@mchsi.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Michael J. Carman

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
