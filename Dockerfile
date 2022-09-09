FROM nginx:1.23.1

RUN apt-get update && \
    apt-get install -y python3 && \
    apt-get install -y python3-pip && \
    apt-get install -y python3-flask && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install gunicorn

VOLUME ["/usr/share/nginx/html"]

# COPY html/* /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]