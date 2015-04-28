use HackaMol::X::NERF;
use Modern::Perl;
use Data::Dumper;

my $a = HackaMol::X::NERF::ext;
my $b = HackaMol::X::NERF::ext_a( $a, 1.5);
my $c = HackaMol::X::NERF::ext_ab($a,$b, 2.5, 109.5);
my $d = HackaMol::X::NERF::ext_abc($a,$b,$c,1.5,120,180.0);

unshift( @{$a},'H' );
unshift( @{$b},'C' );
unshift( @{$c},'N' );
unshift( @{$d},'O');

print "4 \n\n";
printf ("%5s %10.3f %10.3f %10.3f\n", @$_) foreach ($a,$b,$c,$d);

