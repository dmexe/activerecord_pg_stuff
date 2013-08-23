require 'spec_helper'

describe ActiveRecordPgStuff::Relation::TemporaryTable do

  context "temporary_table" do

    let(:rel) { Seller.where(id: [1,2]) }

    it "should create temporary table from relation" do
      rs = rel.temporary_table do |tmp|
        tmp.where(id: [1,2]).load
      end
      expect(rs.map(&:class)).to eq [Seller, Seller]
      expect(rs.map(&:class).map(&:table_name)).to eq %w{ sellers sellers }
      expect(rs.map(&:id)).to eq [1,2]
      expect(rs.map(&:readonly?)).to eq [true, true]
    end

    it "should create nested temporary tables from relation" do
      rs = rel.select("id * 10 AS id").temporary_table do |tmp|
        tmp.where(id: [10]).temporary_table do |nested_tmp|
          nested_tmp.where(id: [10,20]).load
        end
      end
      expect(rs.map(&:id)).to eq [10]
    end

  end

end
