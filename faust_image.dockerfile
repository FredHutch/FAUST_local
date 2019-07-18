FROM r-base:3.6.1

# Install R `devtools` external dependencies
RUN apt-get update \
    && apt-get install --yes libcurl4-openssl-dev \
                             libssl-dev \
                             libxml2-dev

# Install `configr` to support user configurations for FAUST
RUN R -e "install.packages('configr', repos='https://cloud.r-project.org/')"

# Install `devtools` R dependencies
RUN R -e "install.packages('curl', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('xml2', repos='https://cloud.r-project.org/')"
# Install `devtools`
RUN R -e "install.packages('devtools', repos='https://cloud.r-project.org/')"

# Install `FAUST` dependencies
# Install BiocManager
RUN R -e "install.packages(c('BiocManager'), repos='https://cloud.r-project.org/')"
RUN R -e "BiocManager::install('Biobase', update = FALSE)"
RUN R -e "BiocManager::install('flowCore', update = FALSE)"
RUN R -e "BiocManager::install('flowWorkspace', update = FALSE)"
RUN R -e "BiocManager::install('flowWorkspaceData', update = FALSE)"

# Install Required FAUST dependencies
RUN R -e "devtools::install_github('RGLab/scamp')"
RUN R -e "devtools::install_github('RGLab/FAUST')"