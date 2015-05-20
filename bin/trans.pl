#!/usr/bin/env perl
use HackaMol;
use Data::Dumper;

my $mol = HackaMol->new->read_file_mol(shift);

#backbone
my @bb  = map{$mol->get_atoms($_)} 0 .. 3;
my $bb_atoms = HackaMol::AtomGroup->new(atoms => [@bb]);

print Dumper $bb_atoms->COM;
print Dumper $mol->COM;

$mol->translate(-$bb_atoms->COM);
print Dumper $bb_atoms->COM;

$mol->print_xyz;

$bb_atoms->print_xyz;

