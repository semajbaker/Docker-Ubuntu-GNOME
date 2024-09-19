FROM ubuntu:latest

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y ubuntu-desktop dbus-x11

RUN rm /run/reboot-required*

RUN useradd -m user1 -p $(openssl passwd user1)
RUN usermod -aG sudo user1
RUN echo "root:root" | chpasswd

RUN apt install -y xrdp
RUN adduser xrdp ssl-cert

RUN sed -i '3 a echo "\
export GNOME_SHELL_SESSION_MODE=ubuntu\\n\
export XDG_SESSION_TYPE=x11\\n\
export XDG_CURRENT_DESKTOP=ubuntu:GNOME\\n\
export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg\\n\
" > ~/.xsessionrc' /etc/xrdp/startwm.sh
RUN apt-get install -y '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev libxcb-util1

RUN apt-get install -y libgl1-mesa-dev libdbus-1-3
RUN apt-get install -y python3
RUN apt-get install -y cmake
RUN apt-get install -y nano
RUN apt-get install -y iputils-ping
RUN apt-get install -y sudo
RUN apt-get install -y nmap
RUN apt-get install -y pip

RUN apt install -y \
    build-essential flex bison \
    libgtk-3-dev libelf-dev libncurses-dev autoconf \
    libudev-dev libtool zip unzip v4l-utils libssl-dev \
    python3-pip cmake git iputils-ping net-tools dwarves \
    guvcview python-is-python3 bc v4l-utils guvcview

WORKDIR /home/user1/
RUN wget -O Firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"

COPY requirements.txt /
RUN pip install -r requirements.txt --break-system-packages

EXPOSE 3389

CMD service dbus start; /usr/lib/systemd/systemd-logind & service xrdp start ; /bin/bash
