#Build stage
FROM node AS builder

#ARG SRV_IP
#ENV REACT_APP_API_URL=${SRV_IP}

WORKDIR /app-dir


COPY app/fnt/source_code/package*.json ./

RUN npm i react-scripts@latest

COPY app/fnt/source_code/ .

#RUN REACT_APP_API_URL=${SRV_IP} && \
RUN npm run build

#RUN sed -E -i'' "s/(.*API_URL=).*/\1${SRV_IP}/" './.env'

#Final stage
FROM nginx

COPY app/fnt/nginx/default.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app-dir/build /usr/share/nginx/html

EXPOSE 3000
