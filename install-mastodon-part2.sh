#!/bin/sh
# Resume installing ruby  
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 2.6.3 
rbenv global 2.6.3

# Obtain&Install SSL cert
sudo certbot --nginx -d $INSTANCE

# Install bundler 
gem install bundler --no-ri --no-rdoc

# Setting up PostgreSQL
sudo -u postgres psql
	# in PostgreSQL prompt,execute
	# ```
	# CREATE USER mastodon CREATEDB;
	# \q
	# ``` 


# Download Mastodon from github 
git clone https://github.com/tootsuite/mastodon.git live
cd live
git checkout $(git tag -l | grep -v 'rc[0-9]*$' | sort -V | tail -n 1)

# Install the dependencies
gem install bundler
bundle install \
  -j$(getconf _NPROCESSORS_ONLN) \
  --deployment --without development test
yarn install --pure-lockfile --network-timeout 100000

# Set up Mastodon
cd ~/live 
RAILS_ENV=production bundle exec rake mastodon:setup


# Set up nginx
sudo cp /home/mastodon/live/dist/nginx.conf /etc/nginx/conf.d/$INSTANCE.conf
sudo vim /etc/nginx/conf.d/$INSTANCE.conf
	# `:s%/example.com/$INSTANCE/g`
	# uncomment "ssl_certificate" and "ssl_certificate_key"
sudo systemctl reload nginx

# Set up systemd services
sudo cp /home/mastodon/live/dist/mastodon-*.service /etc/systemd/system/
sudo systemctl start mastodon-web mastodon-sidekiq mastodon-streaming
sudo systemctl enable mastodon-web.service mastodon-streaming.service mastodon-sidekiq.service
