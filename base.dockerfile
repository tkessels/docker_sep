FROM ubuntu:20.04 as sep_base
LABEL maintainer=tabledevil
RUN apt-get update && apt-get install -y gcc-multilib ; rm -rf /var/lib/apt/lists/*
ADD installfiles/ /root/installfiles/
WORKDIR /root
RUN /root/installfiles/install.sh -i && rm -rf /root/installfiles
RUN ln -s /opt/Symantec/symantec_antivirus/sav /usr/local/bin/sav
WORKDIR /data


FROM ubuntu:20.04
COPY --from=sep_base / /
