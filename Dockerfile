FROM python:3.9-alpine3.13
LABEL maintainer="shakibreza"

ENV PYTHONUNBUFFERED=1

COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./requirements.txt /tmp/requirements.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false

# Install build dependencies (Alpine needs them)
RUN apk add --no-cache gcc musl-dev libffi-dev make && \
    python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --system \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user