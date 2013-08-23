require 'spec_helper'

describe ActiveRecordPgStuff::Relation::TemporaryTable do

  context "pivot" do

    let(:rel) { Payment }

    it "should create pivot table from relation" do
      rs = rel.select(:seller_id, "SUM(amount) AS amount", "DATE_TRUNC('month', created_at) AS created_at")
              .group("seller_id, DATE_TRUNC('month', created_at)").temporary_table do |tmp|
                tmp.pivot :created_at, :seller_id, :amount
              end

      expect(rs.headers).to eq [nil,1,2]
      expect(rs.rows).to eq [
        [ Time.utc(2012, 9,  1), nil, 5  ],
        [ Time.utc(2012, 10, 1), 1,   7  ],
        [ Time.utc(2012, 11, 1), 3,   24 ],
      ]
    end

  end

end
