FROM ubuntu:16.04

USER root

ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update &&\
    apt-get install -y \
    nginx \
    git \
    ffmpeg \
    libpq-dev \
    python-dev \
    libtiff5-dev \
    libjpeg8-dev \
    libopenjp2-7-dev \
    zlib1g-dev \
    libfreetype6-dev \
    liblcms2-dev \
    libwebp-dev \
    tcl8.6-dev \
    tk8.6-dev \
    python3-tk \
    libharfbuzz-dev \
    libfribidi-dev \
    libxcb1-dev \
    python3 \
    python3-pip \
    postgresql-client &&\

    mkdir -p /opt/zou &&\
    useradd --home /opt/zou zou &&\
    chown zou: /opt/zou


WORKDIR /opt/zou


RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple virtualenv &&\
    cd /opt/zou &&\
    virtualenv zouenv &&\
    . zouenv/bin/activate &&\
    zouenv/bin/pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple zou supervisor &&\
    chown -R zou:www-data . &&\
    rm -rf /root/.cache/pip &&\
    git clone -b build --single-branch --depth 1 https://gitee.com/zclongpop123/kitsu.git /opt/zou/kitsu &&\

    mkdir /opt/zou/previews &&\
    chown -R zou:www-data /opt/zou &&\
 
    mkdir -p /var/log/zou &&\
    chown -R zou:www-data /var/log/zou

ADD ./nginx.conf /etc/nginx/sites-available/zou
ADD ./supervisord.conf /etc/supervisord.conf
ADD ./nginx.conf    /etc/nginx/conf.d/zou.conf
ADD ./gunicorn /etc/zou/gunicorn.conf
ADD ./gunicorn-events /etc/zou/gunicorn-events.conf


RUN ln -s /etc/nginx/sites-available/zou /etc/nginx/sites-enabled/
RUN rm /etc/nginx/sites-enabled/default


EXPOSE 80


CMD ["/opt/zou/zouenv/bin/supervisord", "-c", "/etc/supervisord.conf"]
