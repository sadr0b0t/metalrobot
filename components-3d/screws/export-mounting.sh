#!/bin/sh
# Экспорт по умолчанию: качество отрисовки резьбы 30, качество отрисовки сердечника 100
mkdir export
#M3
openscad -D "dia=3; hi=4; thr=30; cq=30" -o export/mounting_screw-M3x4.stl screws.scad
openscad -D "dia=3; hi=6; thr=30; cq=30" -o export/mounting_screw-M3x6.stl screws.scad
openscad -D "dia=3; hi=8; thr=30; cq=30" -o export/mounting_screw-M3x8.stl screws.scad
openscad -D "dia=3; hi=10; thr=30; cq=30" -o export/mounting_screw-M3x10.stl screws.scad

