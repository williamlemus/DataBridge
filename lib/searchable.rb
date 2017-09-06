require_relative 'db_connection'
require_relative 'sql_object'

module Searchable

  def where(params)
    where_lines = ""
    params.each do |col, _value|
        where_lines << "#{col} = ? AND "
    end
    vals = params.values
    where_lines = where_lines[0...-4]
    result = DBConnection.execute(<<-SQL, *vals)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_lines}
    SQL
    self.parse_all(result)
  end
end

class SQLObject
  extend Searchable
end
