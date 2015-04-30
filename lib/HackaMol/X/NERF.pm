package HackaMol::X::NERF;
 # ABSTRACT: Natural extension reference frame implementation for molecular building 
use 5.008;
use Moo;
use Math::Vector::Real;
use Math::Trig;

my $orig = V(0,0,0);



sub init {
  # adding the first vector
  my $self = shift;
  if (@_ == 3){
    return V(@_);
  }
  else {
    return $orig;
  }
}


sub extend_a {
  #allow the use of optvec to give control over the addition
  my ($self, $a, $R, $optvec) = @_;
  $optvec = V(1,0,0) unless defined($optvec);
  return ($a + $R*$optvec->versor); 
}

sub extend_ab {
  my ($self,$a,$b,$R,$ang) = @_;
  $ang  = deg2rad(180-$ang);
  my ($ba, $j, $k) = ($b-$a)->rotation_base_3d;
  my $c = $b+$ba*$R;
  $c = $j->rotate_3d($ang, $c-$b) + $b;
  return ($c);
}

sub extend_abc {
  my ($self,$a,$b,$c,$R,$ang,$tors) = @_;
  $ang  = deg2rad(180-$ang);
  $tors = deg2rad($tors);
  my $cang = cos($ang);
  my $sang = sin($ang);
  my $ctor = cos($tors);
  my $stor = sin($tors);

  my $bc = ($c-$b)->versor;
  my $n = (($b-$a) x $bc)->versor;

  my $D = $R*($bc*$cang + ($n x $bc)*$sang*$ctor + $n*$sang*$stor) + $c;
  return $D;
}


1;

=method init

optional argument is list of three numbers: x, y, and z. 

Returns an MVR object constructed from V(0,0,0) or V(x,y,z). 

=method extend_a(MVR1, R)

two arguments MVR1 and R, along with optional argument MVR2. 

Returns an MVR object that is a distance R from MVR1. This new vector will be 
displaced along the x axis unless the optional MVR2 is passed. If MVR2 the 
MVR returned is displace by R times the unit vector parallel to MVR1. 

=method extend_ab(MVR1, MVR2, R, ANGLE)

four arguments MVR1, MVR2, R, and ANGLE. 

Returns an MVR object that is a distance R from MVR2 and at ANGLE from MVR1.

=method extend_abc(MVR1, MVR2, MVR3, R, ANGLE, TORSION)

six arguments MVR1, MVR2, MVR3, R, ANGLE, and TORSION. 

Returns an MVR object that is a distance R from MVR3, at ANGLE from MVR2, 
and at TORSION from MVR1 via the vector between MVR2 and MVR3.
 
