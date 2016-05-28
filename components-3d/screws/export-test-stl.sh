#!/bin/sh
mkdir export-test
#M4x14
openscad -D "dia=4; hi=14; thr=10; cq=100" -o export-test/crosshead_screw-M4x14-thr10-cq100.stl screws.scad
openscad -D "dia=4; hi=14; thr=30; cq=30" -o export-test/crosshead_screw-M4x14-thr30-cq30.stl screws.scad
openscad -D "dia=4; hi=14; thr=30; cq=100" -o export-test/crosshead_screw-M4x14-thr30-cq100.stl screws.scad
openscad -D "dia=4; hi=14; thr=100; cq=30" -o export-test/crosshead_screw-M4x14-thr100-cq30.stl screws.scad
openscad -D "dia=4; hi=14; thr=100; cq=100" -o export-test/crosshead_screw-M4x14-thr100-cq100.stl screws.scad
#M4x40
openscad -D "dia=4; hi=40; thr=10; cq=100" -o export-test/crosshead_screw-M4x40-thr10-cq100.stl screws.scad
openscad -D "dia=4; hi=40; thr=30; cq=30" -o export-test/crosshead_screw-M4x40-thr30-cq30.stl screws.scad
openscad -D "dia=4; hi=40; thr=30; cq=100" -o export-test/crosshead_screw-M4x40-thr30-cq100.stl screws.scad
openscad -D "dia=4; hi=40; thr=100; cq=30" -o export-test/crosshead_screw-M4x40-thr100-cq30.stl screws.scad
openscad -D "dia=4; hi=40; thr=100; cq=100" -o export-test/crosshead_screw-M4x40-thr100-cq100.stl screws.scad

