# 使用 nginx 官方的 alpine 镜像作为基础镜像
FROM nginx:alpine

# 删除默认的 Nginx 配置文件
RUN rm /etc/nginx/conf.d/default.conf

# 将自定义的 Nginx 配置文件复制到容器中
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/default.conf /etc/nginx/conf.d/

WORKDIR /var/www/html

# 暴露 8080 端口
EXPOSE 8080

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]
