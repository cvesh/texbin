# Texbin base image

FROM ubuntu
MAINTAINER Daniel Martins <daniel.tritone@gmail.com>

# Install required dependencies
RUN apt-get update
RUN apt-get install -y git curl ruby ruby-dev texlive-full

# Install RVM
RUN curl -L https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.1.1"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

# Application-specific user
RUN useradd -G rvm -s /bin/bash -m -d /texbin texbin

# Create directory from where the code will run
RUN mkdir /texbin/app
RUN chown texbin:texbin /texbin/app

WORKDIR /texbin/app

ENV HOME /texbin
USER texbin

# Make unicorn reachable to other containers
EXPOSE 3000

# If no command is given, run the server after starting the container
CMD ["/bin/bash", "-l", "-c", "foreman start"]

# Install app dependencies in the correct gemset
ADD Gemfile /texbin/app/Gemfile
ADD Gemfile.lock /texbin/app/Gemfile.lock

ADD .ruby-version /texbin/app/.ruby-version
ADD .ruby-gemset /texbin/app/.ruby-gemset

RUN /bin/bash -l -c "bundle install"

# Copy application code to container. Try not to add steps after this one
# so we can use the Docker caching more efficiently
ADD . /texbin/app/
