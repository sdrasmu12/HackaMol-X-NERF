use Modern::Perl;
use HackaMol::X::NERF;
use Math::Vector::Real;
use YAML::XS;
use Scalar::Util qw(looks_like_number);
use List::MoreUtils qw(singleton);

my $bld = HackaMol::X::NERF->new();

my @zmat = <DATA>;
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
print Dump 'A', \%mol; 

foreach my $ib (@iB){
  my $sym = $zmat[$ib];
  my $av  = $bld->init; 
  $mol{atoms}[$ib] = {
                         symbol  =>  $sym ,
                         coords => [ $av ]
                      };
}

print Dump 'B', \%mol; 

foreach my $ic (@iC){
  my ($sym, $iat1, $R) = split (/ /, $zmat[$ic]);
  my $a  = $mol{atoms}[$iat1]{coords}[0];
  print Dump $a;
  #my $b  = $bld->extend_a($a,$R);
  #$mol{atoms}[$ic] = {
  #                       symbol  =>  $sym ,
  #                       coords => [ $b ]
  #                    };
}
exit;
print Dump 'C', \%mol; 

foreach my $id (@iD){
  my ($sym, $iat1, $R, $iat2, $ang) = split (/ /, $zmat[$id]);
  my $a = $mol{atoms}[$iat1]{coords}[0];
  my $b = $mol{atoms}[$iat2]{coords}[0];
  my $av  = $bld->extend_ab($a,$b,$R,$ang);
  $mol{atoms}[$id] = {
                         symbol  =>  $sym ,
                         coords => [ $av ]
                      };
}
print Dump 'D', \%mol; 


foreach my $ie (@iE){
  my ($sym, $iat1, $R, $iat2, $ang, $iat3, $tor) = split (/ /, $zmat[$ie]);
  my $a  = $mol{atoms}[$iat1]{coords}[0];
  my $b  = $mol{atoms}[$iat2]{coords}[0];
  my $c  = $mol{atoms}[$iat3]{coords}[0];
  my $av = $bld->extend_abc($a,$b,$c,$R,$ang,$tor);
  $mol{atoms}[$ie] = {
                         symbol  =>  $sym ,
                         coords => [ $av ]
                      };
}
print Dump 'E', \%mol; 


__DATA__
C
C 1 1.5
C 2 1.5 1 109.0
C 3 1.5 2 109.0 1 180.0
C 4 1.5 3 109.0 2 180.0
C 5 1.5 4 109.0 3 180.0
C 0 10. 10. 10.
C 7 1.5 
C 8 1.5 7 109.0
C 9 1.5 8 109.0 7 180.0
C 10 1.5 9 109.0 8 180.0
C 11 1.5 10 109.0 9 180.0
C 0 11. 11. 11.
C 0 12. 12. 10.
C 0 13. 13. 10.
C 0 14. 14. 10.
