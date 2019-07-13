# NOTICE
**RUN ONLY ON YOUR RESPONSIBLLITY.**  

This branch is For Raspberry Pi.

Fixed for Mastodon v2.7.3 and Ruby 2.6.0 on x64. 

Official Installaton Documentation; <https://docs.joinmastodon.org/administration/installation/#install-fail2ban-so-it-blocks-repeated-login-attempts>


# First of all

## Create user "mastodon"
```
sudo adduser mastodon
sudo adduser mastodon sudo 
su - mastodon
```
##  Set Your Instance Name
```
export INSTANCE=YOURDOMAIN  
```  
# Run the script part1 
```
./install-mastodon-part1.sh
```

## During running part1
This script sometimes opens vim and needs to edit some files mannually.

### Extend swapfile
Change value of `CONF_SWAPSIZE`, like `100` --> `2048`   

# Run part2 
```
./install-mastodon-part2.sh
```
## NOTICE
**Part2 takes A LOT time. Maybe it will take 3 hours.**  

## During running part2
### Setting up PostgreSQL
in PostgreSQL prompt,execute below
```
CREATE USER mastodon CREATEDB;
\q
``` 

### Fix nginx conf file
Edit `/etc/nginx/sites-available/$INSTANCE.conf`  
Replace `example.com` with `YOURDOMAIN`   
Ane then, uncomment `ssl_certificate` and `ssl_certificate_key`  

In Vim, Replacing is easy by using below command
```
:%s/example.com/YOURDOMAIN/g
```

At last, run mastodon:setup  
```
RAILS_ENV=producrion bundle exec rake mastodon:setup
```
