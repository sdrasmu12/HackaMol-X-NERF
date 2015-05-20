#!/usr/bin/env perl
use HackaMol;

my $mol = HackaMol::Molecule->new;

foreach my $zmat (@ARGV){
  my $aa = HackaMol->new->read_file_mol($zmat);
  my @bb  = map{$aa->get_atoms($_)} 0 .. 3;
  my $bb_atoms = HackaMol::AtomGroup->new(atoms => [@bb]);
  $aa->translate(-$bb_atoms->COM);
  $mol->push_atoms($aa->all_atoms);
}

$mol->print_xyz;

