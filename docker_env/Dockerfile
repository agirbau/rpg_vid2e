# Base image with CUDA compiler and dev tools
FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04

# Proxy settings (optional)
ENV no_proxy="10.81.0.0/16,172.16.0.0/16,localhost"
ENV http_proxy="http://10.81.247.64:8080"
ENV https_proxy="http://10.81.247.64:8080"

# Create non-root user
RUN useradd -ms /bin/bash user

# Add /home/user/.local/bin to path
ENV PATH="/home/user/.local/bin:${PATH}"

# Avoid pip root warning
ENV PIP_ROOT_USER_ACTION=ignore

# Install system packages, compilers, OpenCV, Eigen, Boost, pybind11
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3 python3-pip python3-dev python3-setuptools \
    cmake build-essential git curl unzip \
    libopencv-dev libeigen3-dev libboost-all-dev python3-opencv \
    ninja-build \
 && ln -s /usr/bin/python3 /usr/bin/python \
 && pip3 install --upgrade pip

# Install PyTorch + torchvision + torchaudio for CUDA 11.3
RUN pip install torch==1.10.0+cu113 torchvision==0.11.1+cu113 torchaudio==0.10.0+cu113 \
    --index-url https://download.pytorch.org/whl/cu113

# Install your other Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install pybind11 from source (for CMake integration)
RUN git clone --depth 1 https://github.com/pybind/pybind11.git /opt/pybind11 && \
    cd /opt/pybind11 && \
    cmake -DPYBIND11_TEST=OFF -DCMAKE_INSTALL_PREFIX=/usr/local . && \
    make install

# Copy and install ESIM Python bindings
COPY ./esim_py ./esim_py
COPY ./esim_torch ./esim_torch

# Clean any previous build cache that might confuse CMake
RUN rm -rf esim_py/build && pip install ./esim_py/

# Optional: edit esim_torch/setup.py to use dynamic sourcedir if needed
RUN rm -rf esim_torch/build && pip install ./esim_torch/

# Set the home directory and switch to the non-root user
USER user
WORKDIR /home/user/app

# Default command
CMD ["bash"]