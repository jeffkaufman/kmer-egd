for a in A C G T; do
    for b in A C G T; do
        fname_in="s3://prjna729801/hc-HTP-$a$b.gz"
        fname_out="s3://prjna729801/hc-HTP-$a$b.spikes.gz"

        if aws s3 ls "$fname_out" > /dev/null ; then
            # already done
        else
            echo $a$b
            aws s3 cp "$fname_in" - | \
                gunzip | \
                python3 find-spikes.py | \
                gzip | \
                aws s3 cp - "$fname_out" &
        fi
    done
done
wait
         
