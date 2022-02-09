FROM nginx:alpine

COPY nginx.conf /etc/nginx
COPY dist /var/www/html
