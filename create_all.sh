#!/bin/bash

[ -d img ] || btrfs sub create img
[ -d img.no-contours ] || btrfs sub create img.no-contours

for map in dl/mtb*.{exe,7z}; do
  ./create_omtb_garmin_img.sh -o img.no-contours --no-contours $map thin
  ./create_omtb_garmin_img.sh -o img $map thin
done

for map in dl/velo*{exe,7z}; do
  ./create_omtb_garmin_img.sh -o img.no-contours --no-contours $map velo
  ./create_omtb_garmin_img.sh -o img $map velo
done
