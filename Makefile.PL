use ExtUtils::MakeMaker;

if (not -f "config") {
    my $parrot_dir = '';
    while (not ($parrot_dir =~ /^\// and
                -d $parrot_dir and 
                -x "$parrot_dir/parrot" and 
                -f "$parrot_dir/assemble.pl"
               )
          ) {
        print STDERR "Invalid parrot development directory. Try again.\n"
          if $parrot_dir;
        $parrot_dir = prompt("Where is your parrot development directory?");
        if (not $parrot_dir) {
            print STDERR "No parrot development directory specified.\n";
            print STDERR "Giving up.\n";
            exit 1;
        }
    }

    open CONFIG, "> config" or die $!;
    print CONFIG $parrot_dir;
    close CONFIG;
}

WriteMakefile(
    NAME => 'HashBang::ParrotScript',
    VERSION => '0.10',
    PREREQ_PM => {hashbang => '0.10'},
    PL_FILES => {'bin/parrotscript.PERL' => 'bin/parrotscript.pl'},
    EXE_FILES => ['bin/parrotscript.pl'],
    clean => { FILES => 'config bin/parrotscript.pl' },
);

sub MY::postamble {
    <<'END';
pure_install ::
	ln -fs ${INSTALLSCRIPT}/hashbang ${INSTALLSCRIPT}/parrotscript
END
}
