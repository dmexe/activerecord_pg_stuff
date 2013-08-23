module ActiveRecordPgStuff
  module Connection

    module TemporaryTable

      def with_temporary_table(name, sql, &block)
        transaction do
          begin
            sql = sql.gsub(/\n/, ' ').gsub(/ +/, ' ').strip
            sql = "CREATE TEMPORARY TABLE #{name} ON COMMIT DROP AS #{sql}"
            conn.execute sql
            yield name
          ensure
            execute("DROP TABLE IF EXISTS #{name}") rescue nil
          end
        end
      end

    end

  end
end
