#===============================================================================
# Tie-Tk-Text.t
# Last Modified: 11/21/2006 10:54AM
#===============================================================================
# Test suite for Tie::Tk::Text
#===============================================================================
use Tk;
use Test::More tests => 40;

BEGIN { use_ok('Tie::Tk::Text') };

my $mw = MainWindow->new();
my $w  = $mw->Text()->pack();
my @text;

tie @text, 'Tie::Tk::Text', $w;
is(${tied(@text)}, $w, 'TIEARRAY');


# FETCH/STORE, FETCHSIZE, CLEAR
$w->insert('end', "foo\nbar\nbaz\n");

is(@text, 3, 'FETCHSIZE');

is($text[1], "bar\n", 'FETCH');

my $z = $text[1] = "BAR\n";
is($w->get('2.0', '2.0 lineend + 1 chars'), "BAR\n", 'STORE');

$text[5] = "woo\n";
is($w->get('4.0', '6.0 lineend + 1 chars'), "\n\nwoo\n", 'STORE extends');

@text = ();
is($w->get('1.0', 'end'), "\n", 'CLEAR [@a = ()]');

$w->insert('end', "foo\nbar\nbaz\n");
undef @text;
is($w->get('1.0', 'end'), "\n", 'CLEAR [undef @a]');


# PUSH/POP, SHIFT/UNSHIFT
$w->delete('1.0', 'end');
$w->insert('1.0', "three\n");

unshift @text, "one\n", "two\n";
is($w->get('1.0', 'end'), "one\ntwo\nthree\n\n", 'UNSHIFT');

push @text, "four\n", "five\n";
is($w->get('1.0', 'end'), "one\ntwo\nthree\nfour\nfive\n\n", 'PUSH');

is(shift @text, "one\n", 'SHIFT returns line');
is(      @text, 4,       'SHIFT removes line');

is(pop @text, "five\n", 'POP returns line');
is(    @text, 3,        'POP removes line');


# EXISTS/DELETE
$w->delete('1.0', 'end');
$w->insert('1.0', "1\n2\n3\n4\n5\n6\n7\n");

ok( exists $text[2], 'EXISTS (in range)');
ok(!exists $text[7], 'EXISTS (at range boundary)');
ok(!exists $text[8], 'EXISTS (out of range)');

is(delete($text[2]),            "3\n",                    'DELETE $a[x] returns deleted');
is($w->get('1.0', 'end'),       "1\n2\n\n4\n5\n6\n7\n\n", 'DELETE $a[x] clears line');
is(delete(@text[3..4]),         "5\n",                    'DELETE @a[x..y] returns list (not array) in scalar context');
is($w->get('1.0', 'end'),       "1\n2\n\n\n\n6\n7\n\n",   'DELETE @a[x..y] clears lines');
is_deeply([delete @text[5..6]], ["6\n", "7\n"],           'DELETE @a[x..y] returns list in list context');
is($w->get('1.0', 'end'),       "1\n2\n\n",               'DELETE shrinks array');


# STORESIZE
$w->delete('1.0', 'end');
$w->insert('end', "1\n2\n3\n4\n5\n");

$#text = 3;
is(@text, 4, 'STORESIZE deletes');

$#text = 4;
is(@text, 5, 'STORESIZE extends');

$#text = 3;
is(@text, 4, 'STORESIZE deletes');


# SPLICE
$w->delete('1.0', 'end');
$w->insert('end', "1\n2\n3\n4\n5\n");
is_deeply([splice(@text)], ["1\n", "2\n", "3\n", "4\n", "5\n"], 'SPLICE(ARRAY) return list');
is($w->get('1.0', 'end'),  "\n",                                'SPLICE(ARRAY) remainder');

$w->delete('1.0', 'end');
$w->insert('end', "1\n2\n3\n4\n5\n");
is_deeply([splice(@text, 2)], ["3\n", "4\n", "5\n"], 'SPLICE(ARRAY, OFFSET) return list');
is($w->get('1.0', 'end'),     "1\n2\n\n",            'SPLICE(ARRAY, OFFSET) remainder');

$w->delete('1.0', 'end');
$w->insert('end', "1\n2\n3\n4\n5\n");
is_deeply([splice(@text, 2, 2)], ["3\n", "4\n"], 'SPLICE(ARRAY, OFFSET, LENGTH) return list');
is($w->get('1.0', 'end'),        "1\n2\n5\n\n",  'SPLICE(ARRAY, OFFSET, LENGTH) remainder');

$w->delete('1.0', 'end');
$w->insert('end', "1\n2\n3\n4\n5\n");
is_deeply([splice(@text, 2, 2, "A\n", "B\n", "C\n")], ["3\n", "4\n"],         'SPLICE(ARRAY, OFFSET, LENGTH, LIST) return list');
is($w->get('1.0', 'end'),                             "1\n2\nA\nB\nC\n5\n\n", 'SPLICE(ARRAY, OFFSET, LENGTH, LIST) remainder');

$w->delete('1.0', 'end');
$w->insert('end', "1\n2\n3\n4\n5\n");
is_deeply([splice(@text, -2)], ["4\n", "5\n"], 'SPLICE(ARRAY, -OFFSET) return list');
is($w->get('1.0', 'end'),     "1\n2\n3\n\n",   'SPLICE(ARRAY, -OFFSET) remainder');

$w->delete('1.0', 'end');
$w->insert('end', "1\n2\n3\n4\n5\n6\n");
is_deeply([splice(@text, 1, -2)], ["2\n", "3\n", "4\n"], 'SPLICE(ARRAY, OFFSET, -LENGTH) return list');
is($w->get('1.0', 'end'),         "1\n5\n6\n\n",         'SPLICE(ARRAY, OFFSET, -LENGTH) remainder');

$w->delete('1.0', 'end');
$w->insert('end', "1\n2\n3\n4\n5\n6\n");
is_deeply([splice(@text, -5, -2)], ["2\n", "3\n", "4\n"], 'SPLICE(ARRAY, -OFFSET, -LENGTH) return list');
is($w->get('1.0', 'end'),          "1\n5\n6\n\n",         'SPLICE(ARRAY, -OFFSET, -LENGTH) remainder');
