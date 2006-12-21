use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Tie::Tk::Text',
    VERSION_FROM      => 'lib/Tie/Tk/Text.pm',
    PREREQ_PM         => {
    	'Tk' => 0, # otherwise you have nothing to tie() to!
    },
    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/Tie/Tk/Text.pm',
	   AUTHOR         => 'Michael J. Carman <mjcarman@mchsi.com>') : ()),
);
