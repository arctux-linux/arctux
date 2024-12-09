#!/bin/sh
set -e

rsvg-convert -f png -z 1 -o arctux-logo.png arctux-logo.svg
optipng -strip all -o4 -fix -- arctux-logo.png
