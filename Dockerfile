FROM ruby:2.7.1

# リポジトリを更新し依存モジュールをインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential

# Node.jsをインストール
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install nodejs

# yarnパッケージ管理ツールインストール
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

# ワークディレクトリ設定
WORKDIR /myportfolio

# ホストのGemfileとGemfile.lockをコンテナにコピー
COPY Gemfile /myportfolio/Gemfile
COPY Gemfile.lock /myportfolio/Gemfile.lock

# bundle installの実行
RUN gem install bundler
RUN bundle install

# ホストのアプリケーションディレクトリ内をすべてコンテナにコピー
COPY . /myportfolio

# puma.sockを配置するディレクトリを作成
RUN mkdir -p tmp/sockets