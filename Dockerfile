FROM whanos-javascript

COPY app ./app

RUN npm install -g typescript@4.4.3

RUN tsc

RUN find . -name "*.ts" -type f -not -path "./node_modules/*" -delete