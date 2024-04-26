ARG RUBY_VERSION=2.5.1
ARG DEBIAN_RELEASE=stretch
ARG ARCH=amd64

# SHARED BUILD STAGE ==========================================================
# - setup common env variables (that are used in all build stages)
# - set workdir
# - update system gems
FROM --platform=$ARCH ruby:$RUBY_VERSION-slim-$DEBIAN_RELEASE as base

# ARG BUNDLER_VERSION=1.16.5

ENV APP_ROOT=/var/www/todolistapi \
  APP_USER=www-data

ENV LANG=C.UTF-8 \
  GEM_HOME=$APP_ROOT/vendor/bundle \
  BUNDLE_APP_CONFIG=.bundle \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=5

ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_BIN $BUNDLE_PATH/bin
ENV PATH /app/bin:$BUNDLE_BIN:$PATH

WORKDIR $APP_ROOT

# Update rubygems and install bundler
# RUN gem update --system; gem install bundler -v $BUNDLER_VERSION

# FIRST BUILD STAGE
# - install the gems
# - install the packages
FROM base AS intermediate

ARG

ARG DEBIAN_RELEASE

RUN echo "deb http://archive.debian.org/debian $DEBIAN_RELEASE main" > /etc/apt/sources.list && \
  echo "deb http://archive.debian.org/debian-security $DEBIAN_RELEASE/updates main" >> /etc/apt/sources.list

# Install packages necessary for compiling native extensions
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  rm -f /etc/apt/apt.conf.d/docker-clean; \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache; \
  apt-get update -qq && apt-get upgrade -yq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    libpq-dev

COPY Gemfile* .ruby-version ./

RUN bundle i

# BUILDER STAGE - base stage for final builds =================================
# - installs packages
FROM base AS builder

ARG PG_MAJOR=14
ARG DEBIAN_RELEASE

RUN echo "deb http://archive.debian.org/debian $DEBIAN_RELEASE main" > /etc/apt/sources.list && \
  echo "deb http://archive.debian.org/debian-security $DEBIAN_RELEASE/updates main" >> /etc/apt/sources.list

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  rm -f /etc/apt/apt.conf.d/docker-clean; \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache; \
  apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    apt-transport-https \
    gnupg2 \
    wget

# Add PostgreSQL to sources list
RUN wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
  echo "deb https://apt-archive.postgresql.org/pub/repos/apt $DEBIAN_RELEASE-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Update system
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update -qq && apt-get upgrade -yq && \
  # Install required packages
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    # for postgres
    libpq-dev \
    postgresql-client-$PG_MAJOR \
    # debug tools
    vim

FROM builder AS dev

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update -qq && apt-get upgrade -yq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends build-essential

FROM builder as prod

ARG RAILS_ENV

RUN chown -R $APP_USER:$APP_USER /var/www
COPY --chown=$APP_USER:$APP_USER . .
COPY --chown=$APP_USER:$APP_USER --from=intermediate $APP_ROOT $APP_ROOT

USER $APP_USER

RUN bootsnap precompile --gemfile app/ lib/
