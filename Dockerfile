FROM ubuntu:19.04

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -qqy python3 python3-pip

# install libraries required for opencv video rendering
RUN apt-get install -qqy libsm6 libxext6 libxrender-dev

# install opencv for python3
RUN python3 -m pip install opencv-python

# add our frayframe code
ADD frayframe.py /frayframe.py