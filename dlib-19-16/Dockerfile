FROM mettainnovations/ubuntu-base:latest

RUN mkdir -p /home/developer
ENV HOME /home/developer
WORKDIR /home/developer

# Download and Install DLIB
RUN cd ~ && \
    git clone https://github.com/davisking/dlib.git && \
    cd dlib && \
    git checkout v19.16 && \
    git submodule init && \
    git submodule update && \
    mkdir build &&  \
    cd build && \
    cmake -DDLIB_USE_CUDA=1 -DDLIB_USE_BLAS=1 -DDLIB_PNG_SUPPORT=1 -DDLIB_JPEG_SUPPORT=1 -DUSE_AVX_INSTRUCTION=1 .. && \
    make -j4 && \
    make install
