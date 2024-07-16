require_relative '03_associatable'

# Phase IV
module Associatable
  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      cats_tb_name = self.class.table_name
      humans_tb_name = through_options.table_name # humans
      humans_house_id = source_options.foreign_key # :house_id
      houses_tb_name = source_options.table_name # houses
      cats_owner_id = owner_id # 4
      humans_id = humans_tb_name + '.id'
      houses_id = humans_tb_name + '.id'

      results = DBConnection.execute(<<-SQL, cats_owner_id)
        SELECT
          #{houses_tb_name}.*
        FROM
          #{houses_tb_name}
        INNER JOIN
          #{humans_tb_name}
        ON #{humans_house_id} = #{houses_id}
        WHERE
          #{humans_id} = ?
      SQL

      source_options.model_class.parse_all(results).first
    end
  end
end
