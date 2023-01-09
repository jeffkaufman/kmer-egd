#!/usr/bin/env bash

fname_in=$1
fname_out=${fname_in/.gz/-mvl.tsv}

aws s3 cp $fname_in - | \
    gunzip | \
    ./compute-mean-and-variance.py | \
    aws s3 cp - $fname_out

