FROM public.ecr.aws/lambda/python:3.8

RUN yum clean all && yum -y update && yum -y install bzip2 \
    cups-libs \
    dbus-glib \
    gtk3-devel \
    libXinerama.x86_64 \
    lsb \
    wget \
    xorg-x11-server-Xvfb \
    yum-utils

RUN rm -f /usr/local/bin/firefox
RUN wget https://ftp.mozilla.org/pub/firefox/releases/104.0.1/linux-x86_64/en-US/firefox-104.0.1.tar.bz2
RUN tar -xjvf ./firefox-104.0.1.tar.bz2
RUN rm ./firefox-104.0.1.tar.bz2
RUN chmod -R 755 /var/task/firefox
RUN ln -s /var/task/firefox/firefox /usr/local/bin/firefox

RUN rm -f /usr/local/bin/geckodriver
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.31.0/geckodriver-v0.31.0-linux64.tar.gz
RUN tar xzf ./geckodriver-v0.31.0-linux64.tar.gz
RUN rm ./geckodriver-v0.31.0-linux64.tar.gz
RUN chmod 755 /var/task/geckodriver
RUN ln -s /var/task/geckodriver /usr/local/bin/geckodriver

RUN /usr/local/bin/firefox --version
RUN /usr/local/bin/geckodriver --version

COPY requirements.txt ${LAMBDA_TASK_ROOT}

RUN --mount=type=cache,target=/root/.cache/pip python -m pip install --upgrade pip
RUN --mount=type=cache,target=/root/.cache/pip python -m pip install --upgrade setuptools
RUN --mount=type=cache,target=/root/.cache/pip python -m pip install -r requirements.txt

COPY src ${LAMBDA_TASK_ROOT}

# For docker build local testing
RUN python ${LAMBDA_TASK_ROOT}/test_selenium.py

CMD [ "lambda_function.lambda_handler" ]
