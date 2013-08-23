require 'active_record'
require 'active_record/connection_adapters/postgresql_adapter'

require File.expand_path("../activerecord_pg_stuff/version",                    __FILE__)
require File.expand_path("../activerecord_pg_stuff/connection/temporary_table", __FILE__)
require File.expand_path("../activerecord_pg_stuff/relation/temporary_table",   __FILE__)
require File.expand_path("../activerecord_pg_stuff/relation/pivot",             __FILE__)

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send :include, ActiveRecordPgStuff::Connection::TemporaryTable

ActiveRecord::Relation.send :include, ActiveRecordPgStuff::Relation::TemporaryTable
ActiveRecord::Relation.send :include, ActiveRecordPgStuff::Relation::Pivot
