# RailsLiteCreations

- Simple application built on https://github.com/strood/RailsLite
- Create strange names for creations and save them to database, browse all
  creations

## Setup environment:
> $ bundle update

> $ bundle install

### To initialize database:
> $ cat creations.sql | sqlite3 creations.db

### To start server on port 3000:
> $ ruby bin/server.rb
