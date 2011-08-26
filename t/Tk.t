#===============================================================================
# Tk.t
# Test suite wrapper for Perl/Tk
#===============================================================================
use strict;

use FindBin;
use File::Spec::Functions qw'catfile';
use Test::More;
use Tie::Tk::Text;

use vars qw($w);  # C<my $w> wouldn't be visible in C<do 'file'>

if (eval { require Tk }) {
	my $file = catfile($FindBin::Bin, 'Tie-Tk-Text.pl');
	my $mw   = eval { Tk::MainWindow->new() };
	
	unless ($mw) {
		plan skip_all => "Can't create main window";
	}

	$w = $mw->Text();
	do $file;
}
else {
	plan skip_all => 'Tk not installed';
}
