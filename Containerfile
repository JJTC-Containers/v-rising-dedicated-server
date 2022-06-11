FROM docker.io/jjtc/steam-wine-xvfb:latest

LABEL maintainer "JJTC <oci@jjtc.eu>"

COPY entrypoint.sh /

# Game & Query ports
EXPOSE 27015/udp 27016/udp

ENTRYPOINT [ "/entrypoint.sh" ]
