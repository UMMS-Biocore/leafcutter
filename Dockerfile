FROM r-base:3.5.2

LABEL maintainer="Onur Yukselen <onur.yukselen@umassmed.edu>" description="Docker image containing all requirements for the dolphinnext/leafcutter pipeline"

RUN export LC_ALL=C
RUN apt-get update 
RUN apt-get install -y --no-install-recommends \
                ghostscript \
                lmodern \
                pandoc-citeproc \
                qpdf \
                pandoc \
                r-cran-formatr \
                r-cran-ggplot2 \
                r-cran-knitr \
		r-cran-rmarkdown \
                r-cran-runit \
                r-cran-testthat \
                texinfo \
                texlive-fonts-extra \
                texlive-fonts-recommended \
                texlive-latex-extra \
                texlive-latex-recommended \
                texlive-luatex \
                texlive-plain-generic \
                texlive-science \
                texlive-xetex \
		unzip libsqlite3-dev libbz2-dev libssl-dev python python-dev \
                python-pip git libxml2-dev software-properties-common wget tree vim sed \
                subversion g++ gcc gfortran libcurl4-openssl-dev curl zlib1g-dev build-essential \
		libffi-dev  \
        && install.r binb linl pinp tint 

RUN pip install -U "setuptools==3.4.1"
RUN pip install -U "pip==1.5.4"
RUN pip install -U "virtualenv==1.11.4"

RUN R --slave -e "install.packages(c('devtools', 'gplots', 'R.utils','rmarkdown', 'RColorBrewer', 'Cairo'), dependencies = TRUE, repos='https://cloud.r-project.org')"

RUN apt-get clean all
RUN apt-get -y install zip unzip gcc g++ make zlib1g-dev zlibc libbz2-dev liblzma-dev \
    ca-certificates \
    libpq-dev \
    python-pip \
    python2.7 \
    python2.7-dev \
    && apt-get autoremove -y \
    && apt-get clean -y


## Samtools

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

#######################
## leafcutter 0.2.8  ##
#######################
RUN Rscript -e 'install.packages("rstan", repos="https://cran.rstudio.com")'
RUN Rscript -e 'devtools::install_github("davidaknowles/leafcutter/leafcutter")'
RUN Rscript -e 'install.packages("ggplot2", repos="https://cran.rstudio.com")'
RUN cd /usr/src && git clone https://github.com/davidaknowles/leafcutter
ENV PATH=${PATH}:/usr/src/leafcutter/scripts:/usr/src/leafcutter/clustering


RUN mkdir -p /project /nl /mnt /share
