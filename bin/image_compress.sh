#!/bin/bash
fname=`basename ${1} .JPG`
convert -strip -interlace Plane -gaussian-blur 0.05 -quality 85% ${fname}.JPG ${fname}_c.JPG
