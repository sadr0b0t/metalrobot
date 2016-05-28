#!/bin/sh
# Экспорт по умолчанию: качество отрисовки резьбы 30, качество отрисовки сердечника 100
mkdir export
#M3
openscad -D "dia=3; hi=4; thr=30; cq=30" -o export/crosshead_screw-M3x4.stl screws.scad
openscad -D "dia=3; hi=6; thr=30; cq=30" -o export/crosshead_screw-M3x6.stl screws.scad
openscad -D "dia=3; hi=8; thr=30; cq=30" -o export/crosshead_screw-M3x8.stl screws.scad
openscad -D "dia=3; hi=10; thr=30; cq=30" -o export/crosshead_screw-M3x10.stl screws.scad
openscad -D "dia=3; hi=12; thr=30; cq=30" -o export/crosshead_screw-M3x12.stl screws.scad
openscad -D "dia=3; hi=14; thr=30; cq=30" -o export/crosshead_screw-M3x14.stl screws.scad
openscad -D "dia=3; hi=16; thr=30; cq=30" -o export/crosshead_screw-M3x16.stl screws.scad
openscad -D "dia=3; hi=18; thr=30; cq=30" -o export/crosshead_screw-M3x18.stl screws.scad
openscad -D "dia=3; hi=20; thr=30; cq=30" -o export/crosshead_screw-M3x20.stl screws.scad
openscad -D "dia=3; hi=22; thr=30; cq=30" -o export/crosshead_screw-M3x22.stl screws.scad
openscad -D "dia=3; hi=24; thr=30; cq=30" -o export/crosshead_screw-M3x24.stl screws.scad
openscad -D "dia=3; hi=26; thr=30; cq=30" -o export/crosshead_screw-M3x26.stl screws.scad
openscad -D "dia=3; hi=28; thr=30; cq=30" -o export/crosshead_screw-M3x28.stl screws.scad
openscad -D "dia=3; hi=30; thr=30; cq=30" -o export/crosshead_screw-M3x30.stl screws.scad

#M4
openscad -D "dia=4; hi=4; thr=30; cq=30" -o export/crosshead_screw-M4x4.stl screws.scad
openscad -D "dia=4; hi=6; thr=30; cq=30" -o export/crosshead_screw-M4x6.stl screws.scad
openscad -D "dia=4; hi=8; thr=30; cq=30" -o export/crosshead_screw-M4x8.stl screws.scad
openscad -D "dia=4; hi=10; thr=30; cq=30" -o export/crosshead_screw-M4x10.stl screws.scad
openscad -D "dia=4; hi=12; thr=30; cq=30" -o export/crosshead_screw-M4x12.stl screws.scad
openscad -D "dia=4; hi=14; thr=30; cq=30" -o export/crosshead_screw-M4x14.stl screws.scad
openscad -D "dia=4; hi=16; thr=30; cq=30" -o export/crosshead_screw-M4x16.stl screws.scad
openscad -D "dia=4; hi=18; thr=30; cq=30" -o export/crosshead_screw-M4x18.stl screws.scad
openscad -D "dia=4; hi=20; thr=30; cq=30" -o export/crosshead_screw-M4x20.stl screws.scad
openscad -D "dia=4; hi=22; thr=30; cq=30" -o export/crosshead_screw-M4x22.stl screws.scad
openscad -D "dia=4; hi=24; thr=30; cq=30" -o export/crosshead_screw-M4x24.stl screws.scad
openscad -D "dia=4; hi=26; thr=30; cq=30" -o export/crosshead_screw-M4x26.stl screws.scad
openscad -D "dia=4; hi=28; thr=30; cq=30" -o export/crosshead_screw-M4x28.stl screws.scad
openscad -D "dia=4; hi=30; thr=30; cq=30" -o export/crosshead_screw-M4x30.stl screws.scad
openscad -D "dia=4; hi=32; thr=30; cq=30" -o export/crosshead_screw-M4x32.stl screws.scad
openscad -D "dia=4; hi=34; thr=30; cq=30" -o export/crosshead_screw-M4x34.stl screws.scad
openscad -D "dia=4; hi=36; thr=30; cq=30" -o export/crosshead_screw-M4x36.stl screws.scad
openscad -D "dia=4; hi=38; thr=30; cq=30" -o export/crosshead_screw-M4x38.stl screws.scad
openscad -D "dia=4; hi=40; thr=30; cq=30" -o export/crosshead_screw-M4x40.stl screws.scad

