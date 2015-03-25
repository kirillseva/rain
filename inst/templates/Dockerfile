FROM kirillseva/avant-r

MAINTAINER kirillseva "https://github.com/kirillseva"

ADD {{{model_path}}} /root/model

ADD {{{start_server_path}}} /root/start_server.R

RUN chmod +x /root/start_server.R

EXPOSE 8103

ENTRYPOINT ["./root/start_server.R"]
