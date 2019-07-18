# Known
## Failed R dependency installations do not cause the docker image to fail
If you run a dependency install request 
`RUN R -e "install.packages('devtools', repos='https://cloud.r-project.org/')"`

This will always return a 0 as an exit code, even if it fails.

This should fail loudly and break the image
