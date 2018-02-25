# SimpleQueueingSystemApp

In this app, the shipments controller handles creation of shipments. Shipments
are made of inventory items and belong to the warehouse that assembles them.

Ruby version
2.2.4

## To run locally:

* bundle install
* bundle exec rake db:create db:migrate
* rails server

## To run the test suite:

* rbbe rake spec

## Schema Information

### inventory items
column name | data type | details
------------|-----------|-----------------------
product_id  | integer   | not null, foreign key (references product)
inventoriable_id | integer | not null, foreign key (polymorphic, references shipment or warehouse)
inventoriable_type | integer | not null
created_at  | datetime
updated_at  | datetime

### products
column name | data type | details
------------|-----------|-----------------------
name       | string    | not null
created_at  | datetime
updated_at  | datetime

### shipments
column name | data type | details
------------|-----------|-----------------------
warehouse_id | integer   | not null, foreign key (references warehouse)
created_at  | datetime
updated_at  | datetime

### warehouses
column name | data type | details
------------|-----------|-----------------------
created_at  | datetime
updated_at  | datetime
