#!/bin/bash

# remove existing overlay
rm overlay.tgz

# create overlay tgz
cd overlay
tar zcvf ../overlay.tgz *
