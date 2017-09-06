require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.constantize
  end

  def table_name
    self.class_name.downcase.pluralize
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @primary_key = :id
    @foreign_key = :"#{name}_id"
    @class_name = name.capitalize

    options.each do |k, v|
      self.send(:"#{k}=", v)
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @primary_key = :id
    @foreign_key = :"#{self_class_name.singularize.downcase}_id"
    @class_name = name.capitalize.singularize
    options.each do |k, v|
      self.send(:"#{k}=", v)
    end
  end
end

module Associatable
  def belongs_to(name, options = {})
    assoc_options[name] = BelongsToOptions.new(name.to_s, options)
    define_method(name) do
      name_options = self.class.assoc_options[name]
      model_class = name_options.model_class
      model_class.where(id: self.send(name_options.foreign_key)).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name.to_s, self.table_name, options)
    define_method(name) do
      foreign_key_name = options.foreign_key
      assoc_options = {}
      assoc_options[:foreign_key] = self.send(:id)
      model_class = options.model_class
      model_class.where(foreign_key_name => assoc_options[:foreign_key])
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      main_table = source_options.table_name
      through_table = through_options.table_name
      foreign_key = source_options.foreign_key
      id = self.send(:id)
      result = DBConnection.execute(<<-SQL, id)
      SELECT
        #{main_table}.*
      FROM
        #{through_table}
      JOIN
          #{main_table} ON #{through_table}.#{foreign_key} = #{main_table}.id
      WHERE
        #{through_table}.id = ?
      SQL
      source_options.model_class.parse_all(result).first
    end
  end
end

class SQLObject
  extend Associatable
end
