require 'spec_helper'

describe ActiveRecordPgStuff::Connection::TemporaryTable do

  context "with_temporary_table" do
    let(:sql) { "SELECT * FROM sellers WHERE id IN(1,2)" }

    it "should create temporary table with 'name' and 'sql' and drop it after block executed" do
      rs = conn.with_temporary_table 'sellers_tmp', sql do |name|
        conn.select_all("SELECT * FROM #{name}").to_a.map(&:values)
      end
      expect(rs).to eq [[1, "foo"], [2, "bar"]]
      expect {
        conn.execute 'SELECT * FROM sellers_tmp'
      }.to raise_error(ActiveRecord::StatementInvalid, /PG::UndefinedTable/)
    end

    it "should create nested temporary tables" do
      rs = conn.with_temporary_table 'sellers_tmp', sql do |name|
        sql = "SELECT * FROM #{name} WHERE id = 1"
        conn.with_temporary_table 'sellers_tmp_nested', sql do |name_nested|
          conn.select_all("SELECT * FROM #{name_nested}").to_a.map(&:values)
        end
      end
      expect(rs).to eq [[1, "foo"]]
      expect {
        conn.execute 'SELECT * FROM sellers_tmp'
      }.to raise_error(ActiveRecord::StatementInvalid, /PG::UndefinedTable/)
      expect {
        conn.execute 'SELECT * FROM sellers_tmp_nested'
      }.to raise_error(ActiveRecord::StatementInvalid, /PG::UndefinedTable/)
    end

  end
end
