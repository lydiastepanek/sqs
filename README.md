# SQSApp

Ruby version
2.2.4

## To run locally:

Have Postgres running
```
postgres -D /usr/local/var/postgres
```

Then:
```
bundle install
bundle exec rake db:create db:migrate
rails server
```

To see current state, run:
```
# make sure server is running as shown above
rails console
WonderQ.current_state
```
