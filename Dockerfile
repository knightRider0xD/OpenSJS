FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive
ENV PYTHONPATH $PYTHONPATH:/src/

# setup tools
RUN apt update -y
RUN apt install -y build-essential python python-setuptools curl python-pip libssl-dev
RUN apt update -y
RUN apt install -y software-properties-common python3-mysqldb libmysqlclient-dev libffi-dev libssl-dev python3-dev
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN sudo apt-get --yes --force-yes install nodejs

RUN apt install -y nginx supervisor
RUN pip install uwsgi

# Add and install Python modules
ADD requirements.txt /src/requirements.txt
RUN cd /src; pip3 install -r requirements.txt

# Bundle app source
ADD . /src

# configuration
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /src/conf/nginx-app.conf /etc/nginx/sites-enabled/
RUN ln -s /src/conf/supervisor-app.conf /etc/supervisor/conf.d/

RUN cd /src/ && make build

# Expose - note that load balancer terminates SSL
EXPOSE 80

# RUN
CMD ["supervisord", "-n"]

