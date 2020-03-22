FROM ubuntu:19.04

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -qqy make cmake git pkg-config sudo 
RUN apt-get install -qqy python3-dev python3-numpy python3-tk python3-pip bpython
RUN apt-get install -qqy libswscale-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libfreetype6-dev

RUN python3 -m pip install matplotlib

RUN cd \
    && git clone https://github.com/opencv/opencv.git \
    && cd opencv \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j \
    && make install \
    && cd \
    && rm -rf opencv

CMD ["/bin/bash"]