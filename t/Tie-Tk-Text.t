use Tk;
use Test::More tests => 4;

BEGIN { use_ok('Tie::Tk::Text') };

my $mw = MainWindow->new();
my $w  = $mw->Text();
my @text;

tie @text, 'Tie::Tk::Text', $w;
is(${tied(@text)}, $w, 'TIEARRAY');

$w->insert('end', "foo\nbar\nbaz\n");
is(@text, 3, 'FETCHSIZE');
is($text[1], "bar\n", 'FETCH');
