FROM python:3.8.3-alpine

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

USER root

RUN apk update \
    && apk add postgresql-dev gcc python3-dev musl-dev zlib-dev jpeg-dev


RUN pip install --upgrade pip

COPY . .

RUN pip install -r requirements.txt
RUN addgroup -S app && adduser -S app -G app
RUN chown -R app:app /app
USER app
ENTRYPOINT ["sh", "entrypoint.sh"]