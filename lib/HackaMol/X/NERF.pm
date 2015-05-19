package HackaMol::X::NERF;
 # ABSTRACT: Natural extension reference frame implementation for molecular building 

use 5.008;
use Moo;
use Math::Vector::Real;
use Math::Trig; 

with 'HackaMol::Roles::NERFRole';

1;

__END__

=head1 SYNOPSIS

       #Let's build a six member ring 
       use HackaMol::X::NERF;
    
       my $bld = HackaMol::X::NERF->new;
       
       push @vecs, $bld->init() ; 
       push @vecs, $bld->extend_a(  $vecs[0]  ,   1.47              );
       push @vecs, $bld->extend_ab( @vecs[0,1],   1.47, 109.5       );
       push @vecs, $bld->extend_abc(@vecs[0,1,2], 1.47, 109.5,  60 );
       push @vecs, $bld->extend_abc(@vecs[1,2,3], 1.47, 109.5, -60 );
       push @vecs, $bld->extend_abc(@vecs[2,3,4], 1.47, 109.5,  60 );

       printf ("C %10.6f %10.6f %10.6f\n", @$_ ) foreach @vecs;

=head1 DESCRIPTION

The HackaMol::X::NERF library is a quick implementation of the Natural 
Extension Reference Frame method for building cartesian coordinates from 
internal coordinates.  This library currently uses Moo and Math::Vector::Real 
objects, and is thus reasonably fast.  It is experimental. In fact, there are
no substantial tests yet! They will be added soon. 
The API will change and expand.  Currently, the class provides four methods four initializing and extending a vector space. Lend me a hand if you are interested!

Study Z-matrices and the synopsis should be easy to understand. All angles are in degrees.

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
 
