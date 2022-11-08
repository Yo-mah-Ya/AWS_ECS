FROM nginx:perl
#build settings
COPY nginx.conf /etc/nginx
#run settings
EXPOSE 80
CMD ["nginx", "-g", "daemon off; load_module /etc/nginx/modules/ngx_http_perl_module-debug.so;"]
