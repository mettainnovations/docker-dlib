FROM ubuntu:latest		

# Use mirror(JAIST) for apt-get
# RUN sed -i'~' -E "s@http://(..\.)?(archive|security)\.ubuntu\.com/ubuntu@http://ftp.jaist.ac.jp/pub/Linux/ubuntu@g" /etc/apt/sources.list

# Install dependencies
RUN apt-get update -y && \
    apt-get install -y build-essential cmake cmake-curses-gui wget unzip git libavcodec-dev libavutil-dev libavutil-ffmpeg54 libavformat-dev libavfilter-dev libavdevice-dev libjpeg8-dev libpng16-dev libtiff5-dev libx264-dev libgstreamer1.0-dev libboost-all-dev && \
    apt-get install -y libopenblas-dev liblapack-dev qt5-default libqt5svg5-dev qtcreator libqt5serialport5-dev && \
    apt-get clean -y

RUN mkdir -p /home/developer
ENV HOME /home/developer
WORKDIR /home/developer

# Install nvidia driver
RUN  apt install -y module-init-tools wget && \
     wget http://us.download.nvidia.com/XFree86/Linux-x86_64/375.39/NVIDIA-Linux-x86_64-375.39.run && \
     sh NVIDIA-Linux-x86_64-375.39.run -a -N --ui=none --no-kernel-module && \
     rm -rf NVIDIA-Linux-*

# Download and Install OpenCV
RUN git clone https://github.com/opencv/opencv.git && \
    cd opencv && \
    git checkout 3.4.1 && \
    git submodule init && \
    git submodule update && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DWITH_QT=YES -DWITH_OPENMP=YES .. && \
    make -j4 && \
    make install && \
    cd ../.. && \
    rm -rf opencv

# Download and Install DLIB
RUN cd ~ && \
    git clone https://github.com/davisking/dlib.git && \
    cd dlib && \
    git checkout v19.9 && \
    git submodule init && \
    git submodule update && \
    mkdir build &&  \
    cd build && \
    cmake -DDLIB_USE_CUDA=1 -DDLIB_USE_BLAS=1 -DDLIB_PNG_SUPPORT=1 -DDLIB_JPEG_SUPPORT=1 -DUSE_AVX_INSTRUCTION=1 .. && \
    make -j4 && \
    make install && \
    rm -rf ~/dlib

# Casa Blanca and DocumentDBCpp dependencies
RUN apt-get install -y libcpprest-dev libssl-dev uuid-dev

# Download and Build DocumentDBCpp
RUN cd ~ && \
    git clone https://github.com/stalker314314/DocumentDBCpp.git DocumentDBCpp && \
    mkdir docdb.build && \
    cd docdb.build && \
    cmake CASABLANCA_INCLUDE_DIR=/usr/include/ CASABLANCA_LIBRARY=/usr/lib/ ../DocumentDBCpp && \
    make && \
    make install && \
    rm -rf ~/DocumentDBCpp

# Clean up
RUN apt-get remove --purge -y wget unzip

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    mkdir -p /etc/sudoers.d && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer && \
    adduser developer video
USER developer
