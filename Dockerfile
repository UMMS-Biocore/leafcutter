################## BASE IMAGE ######################

FROM brianyee/r-jupyter

################## METADATA ######################

LABEL base_image="continuumio/miniconda:latest"
LABEL version="1"
LABEL software="R"
LABEL software.version="3.5.1"
LABEL about.summary="R-leafcutter + jupyter irkernel"
LABEL about.home="https://github.com/byee4/docker"

################## MAINTAINER ######################
MAINTAINER Onur Yukselen <onur.yukselen@umassmed.edu>

RUN Rscript -e 'install.packages("StanHeaders", repos="https://cran.rstudio.com")'
RUN Rscript -e 'install.packages("rstan", repos="https://cran.rstudio.com")'
RUN Rscript -e 'install.packages("dplyr", repos="https://cran.rstudio.com")'
RUN Rscript -e 'install.packages("rstantools", repos="https://cran.rstudio.com")'
RUN Rscript -e 'devtools::install_github("davidaknowles/leafcutter/leafcutter")'
RUN Rscript -e 'IRkernel::installspec(name = "R-leafcutter", displayname = "R-leafcutter", user = FALSE)'
RUN Rscript -e 'install.packages("ggplot2", repos="https://cran.rstudio.com")'
RUN cd /usr/src && git clone https://github.com/davidaknowles/leafcutter
ENV PATH=${PATH}:/usr/src/leafcutter/scripts:/usr/src/leafcutter/clustering

RUN export LC_ALL=C

RUN R --slave -e "install.packages(c('devtools', 'gplots', 'R.utils','rmarkdown', 'RColorBrewer', 'Cairo'), dependencies = TRUE, repos='https://cloud.r-project.org')"

## Samtools
RUN conda install -c bioconda "samtools==1.3"
## Regtools ###
RUN conda install -c bioconda "regtools==0.5.2"
RUN apt-get update
RUN apt-get install -y cmake zlib1g-dev
# RUN cd /usr/src && git clone https://github.com/griffithlab/regtools && cd regtools/ && mkdir build && cd build/ && cmake .. && make
# ENV PATH=${PATH}:/usr/src/regtools/build

RUN mkdir -p /project /nl /mnt /share
