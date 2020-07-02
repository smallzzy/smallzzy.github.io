## note on sql

* primary key: a unique key to identify each row
  * db usualy use a b+ tree for disk performance
  * a incremental primary key force node update on the right most node?
  * unique, index
  * a primary key can be created over many column
* foreign key: refers to primary key in another table
* not null: does not accept null value
* unique: indicate uniqueness on the column
  * can accept one null value
* check: check value against constraint
* default: provide default value
* index: create index to help with search
* auto increment

## language

* `SELECT *`: not used because access on unnecessary column

