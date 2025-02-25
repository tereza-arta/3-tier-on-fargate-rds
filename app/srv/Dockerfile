FROM node

WORKDIR /app-dir

COPY app/srv/source_code/package*.json ./

RUN npm install

COPY app/srv/source_code/ .

EXPOSE 5000

CMD ["npm", "run", "start"]
