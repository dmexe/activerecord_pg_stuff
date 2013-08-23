module ActiveRecordPgStuff
  module Relation

    class PivotResult
      attr_reader :headers, :rows

      def initialize(header_result, result)
        @headers = [nil] + result_to_array(header_result).map(&:first)
        @rows    =  result_to_array(result)
      end

      def each_row(&block)
        rows.each(&block)
      end

      private
        def result_to_array(result)
          result.to_hash.map do |h|
            result.columns.inject([]) do |a, col|
              a << result.column_types[col].type_cast(h[col])
            end
          end
        end
    end

    module Pivot

      def pivot(row_id, col_id, val_id)

        types_sql = %{ SELECT column_name, data_type FROM information_schema.columns WHERE table_name = #{connection.quote self.table_name} AND column_name IN (#{connection.quote row_id},#{connection.quote val_id}) }
        types = connection.select_all types_sql
        types = types.to_a.map(&:values).inject({}) do |a, v|
          a[v[0]] = v[1]
          a
        end
        row_type = types[row_id.to_s]
        val_type = types[val_id.to_s]

        cols = connection.select_all self.except(:select).select("DISTINCT #{col_id}").order(col_id).to_sql
        cols_list = cols.rows.map(&:first).map do |c|
          "#{col_id}_#{c} #{val_type}"
        end.join(", ")

        rel_1 = connection.quote self.select(row_id, col_id, val_id).order(row_id).to_sql
        rel_2 = connection.quote self.except(:select).select("DISTINCT #{col_id}").order(col_id).to_sql
        sql = %{ SELECT * FROM crosstab(#{rel_1}, #{rel_2}) AS (row_id #{row_type}, #{cols_list}) }
        PivotResult.new cols, connection.select_all(sql)
      end

    end

  end
end

