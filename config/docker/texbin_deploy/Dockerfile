# Texbin image customized for another environment

FROM texbin
MAINTAINER Daniel Martins <daniel.tritone@gmail.com>

# Set the proper environment
ENV RAILS_ENV production

# Custom settings for that environment
ADD env /texbin/app/.env
ADD mongoid.yml /texbin/app/config/mongoid.yml

# Allows the user to write the precompiled assets
RUN rake assets:precompile
