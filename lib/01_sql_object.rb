require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def self.columns
    return @column_names unless @column_names.nil?

    tb_name = table_name
    entries = DBConnection.execute2(<<-SQL)
    SELECT
      *
    FROM
      #{tb_name}
    LIMIT 0
    SQL

    @column_names = entries.flatten.map { |column| column.to_sym }

    @column_names
  end

  def self.finalize!
    columns.each do |column|
      define_method(column) do
        attributes[column]
      end

      define_method("#{column}=") do |variable|
        attributes[column] = variable
      end
    end
  end

  def self.table_name=(table_name)
    @given_table_name = table_name
  end

  def self.table_name
    return name.tableize if @given_table_name.nil?

    @given_table_name
  end

  def self.all
    # return an array of all the records in the DB
    tb_name = table_name
    entries = DBConnection.execute(<<-SQL)
    SELECT
      #{tb_name}.*
    FROM
      #{tb_name}
    SQL
    parse_all(entries)
  end

  def self.parse_all(results)
    results.map do |result|
      new(result)
    end
  end

  def self.find(id_num)
    #  look up a single record by primary key
    tb_name = table_name

    entries = DBConnection.execute(<<-SQL, id_num)
    SELECT
      #{tb_name}.*
    FROM
      #{tb_name}
    WHERE
      id = ?
    SQL

    return nil if entries.empty?

    parse_all(entries).first
  end

  def initialize(params = {})
    params.map do |attr_name, value|
      attribute = attr_name.to_sym
      raise "unknown attribute '#{attribute}'" unless self.class.columns.include?(attribute)

      send("#{attribute}=", value)
    end
  end

  def attributes
    @attributes = {} if @attributes.nil?

    @attributes
  end

  def attribute_values
    self.class.columns.map { |column| send(column) }
  end

  def insert
    # insert a new row into the table to represent the SQLObject
    col_names = self.class.columns.join(', ')
    # self.class.columns is an array of symbols separated by commas e.g. [:water, :air, :fire, :earth]
    # col_names is a string of the what used to be symbols separated by commas e.g. "water, air, fire, earth"
    n_values = self.class.columns.length
    # n_values checks how many columns we have to know how many ? to put in the array 4
    question_marks_arr = (['?'] * n_values)
    # question_marks_arr is an array of n_values times ? e.g. [?, ?, ?, ?]
    question_marks = question_marks_arr.join(', ')
    # question_marks is a string of the question_marks_arr e.g. "?, ?, ?, ?"
    tb_name = self.class.table_name
    values = attribute_values
    query = DBConnection.execute(<<-SQL, *values)
      INSERT INTO
        #{tb_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    # update the row with the id of this SQLObject
    col_names = self.class.columns
    # I get the column names as symbols
    sets = col_names.map { |col| "#{col} = ?" }.join(', ')
    # I join the sets into a big string separated by comas
    obj_id = id
    # is a number
    tb_name = self.class.table_name

    DBConnection.execute(<<-SQL, *attribute_values, obj_id)
      UPDATE
        #{tb_name}
      SET
        #{sets}
      WHERE
        id = ?
    SQL
  end

  def save
    # convenience method that either calls insert/update depending on whether or not the SQLObject already exists in the table.
    insert if id.nil?
    update
  end
end
