# 使用官方的nginx镜像作为基础镜像
FROM nginx:alpine
 
# 删除默认的nginx网站配置文件
RUN rm /etc/nginx/conf.d/default.conf
 
# 复制nginx配置文件到容器中
COPY nginx.conf /etc/nginx/conf.d/
 
# 复制构建好的Vue应用到容器中的nginx可访问的目录
COPY dist/ /usr/share/nginx/html
 
# 暴露80端口
EXPOSE 80
 
# 启动nginx服务
CMD ["nginx", "-g", "daemon off;"]