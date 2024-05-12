# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx:1.25.3-alpine


COPY ./nginx.conf /etc/nginx/conf.d/default.conf


EXPOSE 80

