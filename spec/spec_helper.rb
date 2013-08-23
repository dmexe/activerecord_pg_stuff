Bundler.require(:test)
require 'rspec/autorun'
require 'logger'
require File.expand_path("../../lib/activerecord_pg_stuff", __FILE__)

ActiveRecord::Base.logger = Logger.new(STDOUT)

RSpec.configure do |c|
  c.before(:suite) do
    ActiveRecord::Base.establish_connection
  end

  c.before(:all) do
    conn.execute 'CREATE EXTENSION IF NOT EXISTS tablefunc'
    conn.execute "CREATE TABLE sellers (id integer, name varchar)"
    conn.execute "INSERT INTO sellers VALUES(1, 'foo'), (2, 'bar'), (3, 'baz')"

    conn.execute "CREATE TABLE payments (id integer, amount integer, seller_id integer, created_at timestamp)"
    conn.execute "INSERT INTO payments VALUES(1, 1,  1, '2012-10-12 10:00 UTC')"
    conn.execute "INSERT INTO payments VALUES(2, 3,  1, '2012-11-12 10:00 UTC')"
    conn.execute "INSERT INTO payments VALUES(3, 5,  2, '2012-09-12 10:00 UTC')"
    conn.execute "INSERT INTO payments VALUES(4, 7,  2, '2012-10-12 10:00 UTC')"
    conn.execute "INSERT INTO payments VALUES(5, 11, 2, '2012-11-12 10:00 UTC')"
    conn.execute "INSERT INTO payments VALUES(6, 13, 2, '2012-11-12 10:00 UTC')"
  end

  c.after(:all) do
    conn.execute("DROP TABLE sellers")
    conn.execute("DROP TABLE payments")
  end
end

def conn
  ActiveRecord::Base.connection
end

class Seller < ActiveRecord::Base
end

class Payment < ActiveRecord::Base
end

