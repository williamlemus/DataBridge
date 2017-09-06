require_relative 'db_connection'
require 'active_support/inflector'
require_relative 'searchable'
require_relative 'associtable'


class SQLObject

  def self.columns
    unless @columns
      col = DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
          #{self.table_name}
        SQL
      @columns = col.first.map(&:to_sym)
    end
    @columns
  end


  def self.finalize!
    self.columns.each do |column|
      define_method(column) { self.attributes[column] }
      define_method(:"#{column}=") do |value|
        self.attributes[column] = value
      end
    end
  end

  def self.table_name=(table_name)
    @name = table_name
  end

  def self.table_name
    @name ? @name : self.name.tableize
  end

  def self.all
    all = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      SQL
    parse_all(all)
  end

  def self.parse_all(results)
    obj_array = []
    results.each do |row|
      obj_array << self.new(row)
    end
    obj_array
  end

  def self.find(id)
    result = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        id = ?
      SQL
    return self.new(result.first) unless result.empty?
    nil
  end

  def initialize(params = {})
    col = self.class.columns
    params.each do |k, val|
      raise "unknown attribute '#{k}'" unless col.include?(k.to_sym)
      self.send(:"#{k}=", val)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map{ |c| self.send(c)}
  end

  def insert
    joined_columns = self.class.columns.join(",")
    question_marks = "? ," * joined_columns.count(",") + "?"
    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{joined_columns})
      VALUES
        (#{question_marks})
    SQL
    self.send(:id=, DBConnection.last_insert_row_id)
  end

  def update
    joined_columns = self.class.columns.join(" = ?, ") + " = ?"
    DBConnection.execute(<<-SQL, *attribute_values, self.send(:id))
      UPDATE
        #{self.class.table_name}
      SET
        #{joined_columns}
      WHERE
        id = ?
    SQL
  end

  def save
    if self.class.find(self.send(:id))
      self.update
    else
      self.insert
    end
  end
end
