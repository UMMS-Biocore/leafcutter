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
RUN apt-get install libncurses5 libncurses5-dev
RUN cd /usr/src && wget https://github.com/samtools/samtools/releases/download/1.3/samtools-1.3.tar.bz2 && \
	tar jxf samtools-1.3.tar.bz2 && \
	rm samtools-1.3.tar.bz2 && \
	cd samtools-1.3 && \
	./configure --prefix $(pwd) && \
	make

ENV PATH=${PATH}:/usr/src/samtools-1.3

## Regtools ###
RUN apt-get install -y cmake
RUN cd /usr/src && git clone https://github.com/griffithlab/regtools && cd regtools/ && mkdir build && cd build/ && cmake .. && make
ENV PATH=${PATH}:/usr/src/regtools/build

RUN mkdir -p /project /nl /mnt /share
