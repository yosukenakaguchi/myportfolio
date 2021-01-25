# syntax = docker/dockerfile:experimental

# Node.jsダウンロード用ビルドステージ
FROM ruby:3.0.0 AS nodejs

WORKDIR /tmp

# Node.jsのダウンロード
RUN curl -LO https://nodejs.org/dist/v14.15.0/node-v14.15.0-linux-x64.tar.xz
RUN tar xvf node-v14.15.0-linux-x64.tar.xz
RUN mv node-v14.15.0-linux-x64 node

FROM ruby:3.0.0

# nodejsをインストールしたイメージからnode.jsをコピーする
COPY --from=nodejs /tmp/node /opt/node
ENV PATH /opt/node/bin:$PATH

# アプリケーション起動用のユーザーを追加
RUN useradd -m -u 1000 rails
RUN mkdir /myportfolio && chown rails /myportfolio
USER rails

# yarnのインストール
RUN curl -o- -L https://yarnpkg.com/install.sh | bash
ENV PATH /home/rails/.yarn/bin:/home/rails/.config/yarn/global/node_modules/.bin:$PATH

# ruby-2.7.0でnewした場合を考慮
RUN gem install bundler

WORKDIR /myportfolio

# Dockerのビルドステップキャッシュを利用するため
# 先にGemfileを転送し、bundle installする
COPY --chown=rails Gemfile Gemfile.lock package.json yarn.lock /myportfolio/

RUN bundle config set myportfolio_config .bundle
RUN bundle config set path .cache/bundle
# mount cacheを利用する
RUN --mount=type=cache,uid=1000,target=/myportfolio/.cache/bundle \
    bundle install && \
    mkdir -p vendor && \
    cp -ar .cache/bundle vendor/bundle
RUN bundle config set path vendor/bundle

RUN --mount=type=cache,uid=1000,target=/myportfolio/.cache/node_modules \
    bin/yarn install --modules-folder .cache/node_modules && \
    cp -ar .cache/node_modules node_modules

COPY --chown=rails . /myportfolio

RUN --mount=type=cache,uid=1000,target=/myportfolio/tmp/cache bin/rails assets:precompile

# 実行時にコマンド指定が無い場合に実行されるコマンド
CMD ["bin/rails", "s", "-b", "0.0.0.0"]

# FROM ruby:2.7.1

# # リポジトリを更新し依存モジュールをインストール
# RUN apt-get update -qq && \
#     apt-get install -y build-essential

# # Node.jsをインストール
# RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
#     apt-get install nodejs

# # yarnパッケージ管理ツールインストール
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
#     echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
#     apt-get update && apt-get install -y yarn

# # ワークディレクトリ設定
# WORKDIR /myportfolio

# # ホストのGemfileとGemfile.lockをコンテナにコピー
# COPY Gemfile /myportfolio/Gemfile
# COPY Gemfile.lock /myportfolio/Gemfile.lock

# # bundle installの実行
# RUN gem install bundler
# RUN bundle install

# # ホストのアプリケーションディレクトリ内をすべてコンテナにコピー
# COPY . /myportfolio

# # puma.sockを配置するディレクトリを作成
# RUN mkdir -p tmp/sockets