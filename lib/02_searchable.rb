require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    params_keys = []
    params_values = []
    params.each do |key, value|
      params_keys << "#{key} = ?"
      params_values << value
    end
    params_keys = params_keys.join(' AND ')

    tb_name = table_name
    results = DBConnection.execute(<<-SQL, *params_values)
      SELECT
        *
      FROM
        #{tb_name}
      WHERE
        #{params_keys}

    SQL
    results.map { |db_hash| new(db_hash) }
  end
end

class SQLObject
  extend Searchable
end
