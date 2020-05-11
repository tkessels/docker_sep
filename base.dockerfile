FROM ubuntu:18.04 as sep_base
LABEL maintainer=tabledevil
RUN apt-get update && apt-get install -y wget default-jre lib32ncurses5 lib32z1 sharutils ; rm -rf /var/lib/apt/lists/*
ADD sep.tar.gz /root/
WORKDIR /root
RUN /root/sep/install.sh -i && rm -rf /root/sep
RUN ln -s /opt/Symantec/symantec_antivirus/sav /usr/local/bin/sav
WORKDIR /data

FROM ubuntu:18.04
COPY --from=sep_base / /
