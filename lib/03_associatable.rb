require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    super()
    @foreign_key = options[:foreign_key] || "#{name}_id".to_sym
    @class_name = options[:class_name] || name.capitalize
    @primary_key = options[:primary_key] || :id
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    super()
    @foreign_key = options[:foreign_key] || "#{self_class_name}_id".downcase.to_sym
    @class_name = options[:class_name] || name.singularize.capitalize
    @primary_key = options[:primary_key] || :id
  end
end

module Associatable
  def belongs_to(name, options = {})
    bt = BelongsToOptions.new(name.to_s, options)
    assoc_options[name] = bt

    define_method(name) do
      foreign_key_value = send(bt.foreign_key)
      bt.model_class.where(id: foreign_key_value).first
    end
  end

  def has_many(name, options = {})
    define_method(name) do
      hm = HasManyOptions.new(name.to_s, self.class.to_s, options)
      hm.model_class.where(hm.foreign_key => id)
    end
  end

  def assoc_options
    @assoc_options = @assoc_options.nil? ? {} : @assoc_options
    @assoc_options
  end
end

class SQLObject
  extend Associatable
end
