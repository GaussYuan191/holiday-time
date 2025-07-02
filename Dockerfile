FROM node:22-alpine as build-stage

WORKDIR /root/app

COPY . .

RUN npm config set registry https://registry.npmmirror.com/

RUN npm i -g pnpm && pnpm i && pnpm build

FROM nginx:alpine as production-stage

COPY --from=build-stage /root/app/nginx/nginx.conf /etc/nginx/nginx.conf

COPY --from=build-stage /root/app/nginx/conf.d/* /etc/nginx/conf.d/

COPY --from=build-stage /root/app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
