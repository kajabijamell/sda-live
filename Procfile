release: bin/rake db:migrate
web: bin/rails server -p $PORT -e $RAILS_ENV
sidekiq: bundle exec sidekiq -c 2 -q default
