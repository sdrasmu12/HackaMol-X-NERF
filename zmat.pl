use Modern::Perl;
use HackaMol::X::NERF;
use Math::Vector::Real;
use HackaMol;
use YAML::XS;
use List::MoreUtils qw(singleton);

my $bld = HackaMol::X::NERF->new();

my @zmat = <DATA>;
chomp @zmat;
# we have 5 types of extensions
# A. SYM 0 x y z
# B. SYM 
# C. SYM i R
# D. SYM i R j Ang
# E. SYM i R j Ang k Tors
# we need to filter the indices (can't lose the location)

#type A
my @iA = grep {$zmat[$_] =~ m/^\s*\w+\s+0(\s+\d+\.*\d*){3}/} 0 .. $#zmat;
my @inA = singleton (0 .. $#zmat, @iA);
my @iB = grep {$zmat[$_] =~ m/^\s*\w+\s*$/} @inA;
#die "empty atom not on first line" if ( $iB[-1] != 0 );
my @iC = grep {$zmat[$_] =~ m/^\s*\w+(\s+\d+\s+\d+\.*\d*)\s*$/} @inA;
my @iD = grep {$zmat[$_] =~ m/^\s*\w+(\s+\d+\s+\d+\.*\d*){2}\s*$/} @inA;
#warn "insufficient information in type C or type D" unless (scalar(@iC) <= 1 and scalar(@iD) <= 1);
my @iE = grep {$zmat[$_] =~ m/^\s*\w+(\s+\d+\s+\d+.*\d*){3}\s*$/} @inA ;

my %mol;

foreach my $ia (@iA){
  my ($sym, $iat1, @xyz) = split (/ /, $zmat[$ia]);
  $mol{atoms}[$ia] = {
                         symbol  =>  $sym ,
                         coords => [ V(@xyz) ]
                      };
}
#print Dump 'A', \%mol; 

foreach my $ib (@iB){
  my $sym = $zmat[$ib];
  my $a   = $bld->init; 
  $mol{atoms}[$ib] = {
                         symbol  =>  $sym ,
                         coords => [ $a ]
                      };
}

#print Dump 'B', \%mol; 

foreach my $ic (@iC){
  my ($sym, $iat1, $R) = split (/ /, $zmat[$ic]);
  my $a  = $mol{atoms}[$iat1-1]{coords}[0];
  my $b  = $bld->extend_a($a,$R); 
  $mol{atoms}[$ic] = {
                         symbol  =>  $sym ,
                         coords => [ $b ]
                     };
}
#print Dump 'C', \%mol; 

foreach my $id (@iD){
  my ($sym, $iat1, $R, $iat2, $ang) = split (/ /, $zmat[$id]);
  my $a = $mol{atoms}[$iat1-1]{coords}[0];
  my $b = $mol{atoms}[$iat2-1]{coords}[0];
  my $c   = $bld->extend_ab($b,$a,$R,$ang);
  $mol{atoms}[$id] = {
                         symbol  =>  $sym ,
                         coords => [ $c ]
                      };
}
#print Dump 'D', \%mol; 

foreach my $ie (@iE){
  my ($sym, $iat1, $R, $iat2, $ang, $iat3, $tor) = split (/ /, $zmat[$ie]);
  my $a  = $mol{atoms}[$iat1-1]{coords}[0];
  my $b  = $mol{atoms}[$iat2-1]{coords}[0];
  my $c  = $mol{atoms}[$iat3-1]{coords}[0];
  my $d = $bld->extend_abc($c,$b,$a,$R,$ang,$tor);
  $mol{atoms}[$ie] = {
                         symbol  =>  $sym ,
                         coords => [ $d ]
                      };
}
#print Dump 'E', \%mol; 

my $mol = HackaMol::Molecule->new(atoms => [ map{HackaMol::Atom->new($_)} @{$mol{atoms}}]);
$mol->print_xyz;

__DATA__
C
C 1 1.50 
C 2 1.50 1 109       
C 3 1.50 2 109 1 180 
C 4 1.50 3 109 2 180 
C 5 1.50 4 109 3 180
