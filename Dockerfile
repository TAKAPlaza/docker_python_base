FROM ubuntu:18.04
USER root

RUN apt-get update && apt-get -y install locales && localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9
ENV TERM xterm

COPY requirements.txt /root/
RUN apt-get update && apt update
RUN apt-get install -y python3-pip git curl #python install 後に pip install は NG
# Python3.7 in system --------------------------------------
# RUN apt install -y software-properties-common
# RUN add-apt-repository ppa:deadsnakes/ppa
# RUN apt update && apt install -y python3.7 # python3.7.5
# RUN echo 'alias python="/usr/bin/python3.7"' >> ~/.bashrc # Dockerfiles内では無効
# Pyenv--------------------------------------------------------
ENV HOME /root
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/bin:$PYENV_ROOT/shims:$PYENV_ROOT/versions/3.7.11/bin:$PATH
#PATH は壱カ所にまとめて記載. 上書きされるバグ.エラーを起こしやすいので上めに記載。
#..versions/..はdocker起動時のjupyterlab起動に必要
RUN apt-get install -y zlib1g-dev libssl-dev libbz2-dev libncurses5-dev libncursesw5-dev libffi-dev libreadline-dev libsqlite3-dev liblzma-dev libc6 build-essential
RUN git clone https://github.com/yyuu/pyenv.git $HOME/.pyenv
RUN echo 'eval "$(pyenv init -)"' >> ~/.bashrc && eval "$(pyenv init -)"
RUN pyenv install 3.7.11 #/root/.pyenv/shims/python
RUN pyenv global 3.7.11
RUN python3.7 -m pip install -r /root/requirements.txt
# venv------------------------------------------------------------
# RUN apt-get update && apt-get install -y python3.7-venv
# RUN python3.7 -m venv ./venv #上記Python3.7 で install to /venv/bin/python3.7
# RUN . venv/bin/activate && pip install -U pip && pip install -r /root/requirements.txt
# ENV PATH /venv/bin:$PATH
# pip--------------------------------------------------------------
RUN python3.7 -m pip install --upgrade pip setuptools 
RUN python3.7 -m pip install --no-cache-dir jupyterlab black ipykernel ipython jupyterlab_code_formatter jupyterlab-git lckr-jupyterlab-variableinspector jupyterlab_widgets ipywidgets import-ipynb jupyterlab-language-pack-ja-JP