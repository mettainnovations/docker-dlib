FROM mettainnovations/dlib:dlib19.9-cuda8.0	

# Use mirror(JAIST) for apt-get
# RUN sed -i'~' -E "s@http://(..\.)?(archive|security)\.ubuntu\.com/ubuntu@http://ftp.jaist.ac.jp/pub/Linux/ubuntu@g" /etc/apt/sources.list

# Download and Install OpenCV
RUN git clone https://github.com/opencv/opencv.git && \
    cd opencv && \
    git checkout 3.4.1 && \
    git submodule init && \
    git submodule update && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -DWITH_QT=YES -DWITH_OPENMP=YES -DWITH_CUDA=YES -DCMAKE_CXX_FLAGS="-Wno-deprecated-declarations" -DCUDA_ARCH_BIN="30 35" .. && \
    make -j4 && \
    make install && \
    cd ../.. && \
    rm -rf opencv
