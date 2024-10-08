#FROM ubuntu:mantic
FROM ubuntu:latest
#FROM ubuntu:24.04@sha256:3f85b7caad41a95462cf5b787d8a04604c8262cdcdf9a472b8c52ef83375fe15
#FROM ubuntu@sha256:50ec5c3a1814f5ef82a564fae94f6b4c5d550bb71614ba6cfe8fadbd8ada9f12
#FROM ubuntu@sha256:218bb51abbd1864df8be26166f847547b3851a89999ca7bfceb85ca9b5d2e95d
#FROM phusion/baseimage:master-amd64
#FROM ubuntu:22.04@sha256:b4b521bfcec90b11d2869e00fe1f2380c21cbfcd799ee35df8bd7ac09e6f63ea AS base

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt install -y \
    libc6-dbg \
    gcc-multilib \
    lib32stdc++6 \
    g++-multilib \
    sudo \
    cmake \
    ipython3 \
    vim \
    net-tools \
    iputils-ping \
    libffi-dev \
    libssl-dev \
    python3-dev \
    python3-pip \
    build-essential \
    ruby \
    ruby-dev \
    tmux \
    strace \
    ltrace \
    nasm \
    wget \
    gdb \
    gdb-multiarch \
    socat \
    git \
    patchelf \
    gawk \
    file \
    bison \
    rpm2cpio cpio \
    zstd \
    tzdata --fix-missing \
    libpixman-1-dev \
    libsnappy-dev \
    libpng16-16 \
    libpulse-dev \
    qemu-user \
    qemu-system-x86 \
    musl-tools \
    musl \
    gdbserver \
    gcc-arm-none-eabi \
    curl \
    libusbredirparser-dev && \
    rm -rf /var/lib/apt/list/*

RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

#RUN pipx ensurepath && \
#    pipx install ropgadget && \
#    pipx install z3-solver && \
#    pipx install ropper && \
#    pipx install unicorn && \
#    pipx install keystone-engine && \
#    pipx install capstone && \
#    pipx install angr && \
#    pipx install pebble && \
#    pipx install r2pipe

RUN pip3 install --no-cache-dir \
    ropgadget \
    z3-solver \
    smmap2 \
    apscheduler \
    ropper \
    unicorn \
    keystone-engine \
    capstone \
    angr \
    pebble \
    r2pipe \
    pwntools \
    
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN gem install one_gadget seccomp-tools && rm -rf /var/lib/gems/2.*/cache/*

RUN git clone --depth 1 https://github.com/pwndbg/pwndbg && \
    cd pwndbg && chmod +x setup.sh && ./setup.sh

RUN git clone https://github.com/martinradev/gdb-pt-dump.git && \
    cd gdb-pt-dump && echo "source $PWD/pt.py" >> /root/.gdbinit

#RUN git clone https://github.com/Ollrogge/gdb-pt-dump.git && \
#    cd gdb-pt-dump && echo "source $PWD/pt.py" >> /root/.gdbinit

#RUN wget -O ~/.gdbinit-gef.py -q http://gef.blah.cat/py
#RUN wget -q https://raw.githubusercontent.com/bata24/gef/dev/install.sh -O- | sh
#RUN sed -i 's/^\(source \/root\/.gdbinit-gef.py\)$/#\1/' ~/.gdbinit

RUN git clone https://github.com/Ollrogge/Get_musl_headers && cd Get_musl_headers && \
    chmod +x get_musl_headers && ./get_musl_headers

RUN echo "set -g mouse on" >> ~/.tmux.conf

WORKDIR /ctf/work/

COPY linux_server linux_server64  /ctf/

RUN chmod a+x /ctf/linux_server /ctf/linux_server64

#CMD ["/sbin/my_init"]
