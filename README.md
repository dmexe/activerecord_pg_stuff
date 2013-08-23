# ActiveRecordPgStuff

Adds support for working with temporary tables and pivot tables (PostgreSQL only).

## Installation

Add this line to your application's Gemfile:

    gem 'activerecord_pg_stuff'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord_pg_stuff

## Usage

##### Temporary tables

    User.select(:id, :email).temporary_table do |rel|
      rel.pluck(:id)
    end

##### Pivot tables

    CREATE TABLE payments (id integer, amount integer, seller_id integer, created_at timestamp)
    INSERT INTO payments
      VALUES (1, 1,  1, '2012-10-12 10:00 UTC'),
             (2, 3,  1, '2012-11-12 10:00 UTC'),
             (3, 5,  2, '2012-09-12 10:00 UTC'),
             (4, 7,  2, '2012-10-12 10:00 UTC'),
             (5, 11, 2, '2012-11-12 10:00 UTC'),
             (6, 13, 2, '2012-11-12 10:00 UTC')

    Payment
      .select("SUM(amount) AS amount", :seller_id, "DATE_TRUNC('month', created_at) AS month")
      .group("seller_id, DATE_TRUNC('month', created_at)")
      .temporary_table do |rel|
        # :month     - for row
        # :seller_id - for column
        # :amount    - for value
        rel.pivot(:month, :seller_id, :amount)
    end

    expect(result.headers).to eq [nil, 1, 2]

    expect(result.rows).to eq [
      [ Time.utc(2012, 9,  1), nil, 5  ],
      [ Time.utc(2012, 10, 1), 1,   7  ],
      [ Time.utc(2012, 11, 1), 3,   24 ],
    ]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
