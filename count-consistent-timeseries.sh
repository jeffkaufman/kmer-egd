for wtp in $(cat longest-timeseries.tsv | awk '{print $3}' | sort | uniq); do
  for a in A C G T; do
    for b in A C G T; do
        fname_out="s3://prjna729801/clean-TS-$wtp-$a$b.gz"

        if aws s3 ls "$fname_out" > /dev/null ; then
            continue
        fi

        echo "... $a$b"
        time cat longest-timeseries.tsv | \
            awk -F '{print $1}' | \
            xargs -P1 -I {} aws s3 cp s3://prjna729801/{} - | \
            gunzip | \
            sed -E 's/^@MT?_/@/' | \
            ./hash-count-rothman $wtp $a$b | \
            gzip | \
            aws s3 cp - "$fname_out"
    done
  done
done