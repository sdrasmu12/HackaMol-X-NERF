#!/usr/bin/env perl
use HackaMol;

HackaMol->new->read_file_mol(shift)->print_xyz;

