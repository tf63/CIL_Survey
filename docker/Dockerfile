# syntax=docker/dockerfile:1
FROM nvidia/cuda:11.1.1-cudnn8-runtime-ubuntu20.04

# ワークディレクトリの指定
WORKDIR /app
# 非インタラクティブモードにする (入力待ちでブロックしなくなる)
ENV DEBIAN_FRONTEND=noninteractive
# .pycを作らないように
ENV PYTHONDONTWRITEBYTECODE 1
# バッファの無効化
ENV PYTHONUNBUFFERED 1
# torchvisionでpretrainedのモデルを保存する場所
ENV TORCH_HOME /app/.cache

# ----------------------------------------------------------------
# setup (root) 
# ----------------------------------------------------------------
RUN apt update && \
    apt install -y \
    wget \
    bzip2 \
    build-essential \
    git \
    git-lfs \
    curl \
    ca-certificates \
    libsndfile1-dev \
    libgl1 \
    python3.8 \
    python3.8-venv \
    python3-pip

# ----------------------------------------------------------------
# create user
# ----------------------------------------------------------------
# UIDとGIDは外から与える
ARG USER_UID
ARG USER_GID

# コンテナ内でのユーザー名， グループ名
ARG USER_NAME=user
ARG GROUP_NAME=user

# グループが存在しなかったら，　適当なグループを作成
RUN if ! getent group $USER_GID >/dev/null; then \
    groupadd -g $USER_GID $GROUP_NAME; \
    fi

# ユーザーを作成
RUN useradd -m -u $USER_UID -g $USER_GID -s /bin/bash $USER_NAME

# 初期ユーザーの変更
USER $USER_NAME

# ----------------------------------------------------------------
# setup (user) 
# ----------------------------------------------------------------

##################################################################
# poetryインストール
# RUN curl -sSL https://install.python-poetry.org | python3 -

# Poetryのパスを通す
ENV PATH /home/user/.local/bin:$PATH

# vscodeが仮想環境を読み込むようにする
# RUN poetry config virtualenvs.in-project true
##################################################################

# requirements.txtをコピー
COPY docker/requirements.txt /app

RUN pip3 install --no-cache-dir -U pip setuptools wheel

# 先にtorchを入れておく
RUN pip3 install --no-cache-dir torch==1.8.1+cu111 torchvision==0.9.1+cu111 -f https://download.pytorch.org/whl/torch_stable.html 

# その他のライブラリのインストール
RUN pip3 install --no-cache-dir -r requirements.txt
