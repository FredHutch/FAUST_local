rm -fr output_files/*

docker run -it \
           --volume $(pwd):/opt/faust \
           --workdir /opt/faust \
           rglab/faust-local:0.0.2.901 \
           Rscript run_faust.R
