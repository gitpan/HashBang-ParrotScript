use Config;
use File::Basename qw(basename dirname);

open CONFIG, "config" or die $!;
my $parrot = <CONFIG>;
close CONFIG;

chdir(dirname($0));
($file = basename($0)) =~ s/\.PERL$/\.pl/;

open OUT,">$file" or die "Can't create $file: $!";
chmod(0755, $file);
print "Extracting $file (with variable substitutions)\n";

my $prog = join '', <<"!GROK!THIS!", <<'!NO!SUBS!'; $prog =~ s/\<\%parrot\%\>/$parrot/g; print OUT $prog;
$Config{'startperl'} -w

!GROK!THIS!
use strict;

open SCRIPT, shift(@ARGV) or die $!;
undef $/;
my $script = <SCRIPT>;
close SCRIPT;

open PASM, "> .pasm" or die $!;
print PASM $script;
system("perl <%parrot%>/assemble.pl .pasm | <%parrot%>/parrot - @ARGV") == 0 or die; 
unlink ".pasm";

!NO!SUBS!

#vim :set ft=perl
