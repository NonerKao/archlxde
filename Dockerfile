FROM base/archlinux
MAINTAINER Quey-Liang Kao <s101062801@m101.nthu.edu.tw>
# Last Modified: 2015/10/4

RUN curl http://www.oz.nthu.edu.tw/~u9662316/mirrorlist > mirrorlist
RUN rm -f /etc/pacman.d/mirrorlist
RUN mv mirrorlist /etc/pacman.d/mirrorlist
RUN pacman -Syy
RUN echo "Y" | pacman -S archlinux-keyring
RUN echo -en "Y\nY\nY\nY\n" | pacman -Syyu
RUN pacman-db-upgrade
RUN echo "Y" | pacman -S openssh openssl
RUN curl http://www.oz.nthu.edu.tw/~u9662316/shadow > shadow
RUN rm -f /etc/shadow
RUN mv shadow /etc/shadow
RUN sed -i 's/UsePrivilegeSeparation\(.*\)sandbox/UsePrivilegeSeparation no/' /etc/ssh/sshd_config
RUN sed -i 's/#StrictModes yes/StrictModes no/' /etc/ssh/sshd_config
RUN sed -i 's/.*UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
RUN sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/' /etc/ssh/sshd_config
RUN sed -i 's/.*StrictHostKeyChecking.*/StrictHostKeyChecking no/' /etc/ssh/ssh_config
# disable prompt for first-time login
RUN sed -i 's/.*UsePAM.*/UsePAM no/' /etc/ssh/sshd_config
RUN sed -i 's/PrintMotd.*/PrintMotd yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/PrintMotd.*/PrintMotd yes/' /etc/ssh/sshd_config
RUN ssh-keygen -A

EXPOSE 22

RUN echo -en "1\nY\n" | pacman -S xorg-server-xvfb x11vnc
RUN echo -en "\nY\nY\nY\n" | pacman -S lxde
RUN echo -en "Y\n" | pacman -S glib2
RUN echo "cs135702" > VncPassword.txt
RUN rm -f /etc/localtime
RUN ln -s /usr/share/zoneinfo/Asia/Taipei /etc/localtime

ADD startup.sh /
#ADD .config /root/.config
RUN chmod 775 /startup.sh
EXPOSE 5678
ENTRYPOINT ["/startup.sh"]

