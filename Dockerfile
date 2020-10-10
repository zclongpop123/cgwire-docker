FROM krallin/ubuntu-tini:bionic

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN sed -i 's/archive.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list &&\
    sed -i 's/security.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common
RUN apt-get update && apt-get install --no-install-recommends -q -y \
    bzip2 \
    ffmpeg \
    git \
    nginx \
    postgresql-client \
    python-pip \
    python-setuptools \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-venv \
    python3-wheel &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U &&\
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

RUN mkdir -p /opt/zou /var/log/zou /opt/zou/previews

RUN git clone -b build --single-branch --depth 1 https://gitee.com/zclongpop123/kitsu.git /opt/zou/kitsu

WORKDIR /opt/zou/zou

RUN python3 -m venv /opt/zou/env && \
    # Python 2 needed for supervisord
    /opt/zou/env/bin/pip install --upgrade pip setuptools wheel && \
    /opt/zou/env/bin/pip install zou && \
    rm -rf /root/.cache/pip/

WORKDIR /opt/zou

COPY ./gunicorn.conf /etc/zou/gunicorn.conf
COPY ./gunicorn-events.conf /etc/zou/gunicorn-events.conf

COPY ./nginx.conf /etc/nginx/sites-available/zou
RUN ln -s /etc/nginx/sites-available/zou /etc/nginx/sites-enabled/
RUN rm /etc/nginx/sites-enabled/default

RUN pip install supervisor
ADD supervisord.conf /etc/supervisord.conf

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/tini", "--"]

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
