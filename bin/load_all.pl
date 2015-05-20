#!/usr/bin/env perl
use HackaMol;

my $mol = HackaMol::Molecule->new;

foreach my $zmat (@ARGV){
  my @atoms = HackaMol->new->read_file_atoms($zmat);
  $mol->push_atoms(@atoms);
}

$mol->print_xyz;

