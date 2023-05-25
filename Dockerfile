FROM ubuntu:23.04
#FROM phusion/baseimage:master-amd64

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt install -y \
    libc6:i386 \
    libc6-dbg:i386 \
    libc6-dbg \
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
    python3-distutils \
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
    pipx \
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

RUN python3 -m pip install --break-system-packages -U pip && \
    pip install --break-system-packages --no-cache-dir \
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
    pwntools


RUN gem install one_gadget seccomp-tools && rm -rf /var/lib/gems/2.*/cache/*

RUN git clone --depth 1 https://github.com/pwndbg/pwndbg && \
    cd pwndbg && chmod +x setup.sh && ./setup.sh

RUN git clone --depth 1 https://github.com/scwuaptx/Pwngdb.git ~/Pwngdb && \
    cd ~/Pwngdb && mv .gdbinit .gdbinit-pwngdb && \
    sed -i "s?source ~/peda/peda.py?# source ~/peda/peda.py?g" .gdbinit-pwngdb && \
    echo "source ~/Pwngdb/.gdbinit-pwngdb" >> ~/.gdbinit

RUN git clone https://github.com/Ollrogge/gdb-pt-dump.git && \
    cd gdb-pt-dump && echo "source $PWD/pt.py" >> /root/.gdbinit

#RUN wget -O ~/.gdbinit-gef.py -q http://gef.blah.cat/py
RUN wget -q https://raw.githubusercontent.com/bata24/gef/dev/install.sh -O- | sh
RUN sed -i 's/^\(source \/root\/.gdbinit-gef.py\)$/#\1/' ~/.gdbinit

RUN git clone https://github.com/Ollrogge/Get_musl_headers && cd Get_musl_headers && \
    chmod +x get_musl_headers && ./get_musl_headers

WORKDIR /ctf/work/

COPY linux_server linux_server64  /ctf/

RUN chmod a+x /ctf/linux_server /ctf/linux_server64

CMD ["/sbin/my_init"]
