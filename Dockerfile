# Texbin base image

FROM ubuntu
MAINTAINER Daniel Martins <daniel.tritone@gmail.com>

# Install required dependencies
RUN apt-get update
RUN apt-get install -y ruby2.0 ruby2.0-dev bundler texlive-full

# Create directory from where the code will run
RUN mkdir -p /texbin/app
WORKDIR /texbin/app

# Make unicorn reachable to other containers
EXPOSE 3000

# Exposes the public directory as a volume
VOLUME /texbin/app/public

# Container should behave like an executable that runs
# foreman start by default
CMD ["start"]
ENTRYPOINT ["foreman"]

# Install app dependencies in the correct gemset
ADD Gemfile /texbin/app/Gemfile
ADD Gemfile.lock /texbin/app/Gemfile.lock
RUN bundle install

# Copy application code to container. Try not to add steps after this one
# so we can use the Docker caching more efficiently
ADD . /texbin/app/
