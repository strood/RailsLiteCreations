require_relative '../../lib/active_record_base.rb'
require_relative '../../db/db_connection'

class Owner < SQLObject
  attr_accessor :id, :owner_name, :owner_rating
    # TODO : mas_many association

  self.table_name = 'owners'

  def initialize(options = {})
    @id = options['id']
    @owner_name = options['owner_name']
    @owner_rating = options['owner_rating']
  end

  def self.find_by_name(owner_name)
    result = DBConnection.instance.execute(<<-SQL, owner_name)
      SELECT
        *
      FROM
        owners
      WHERE
        owner_name = ?
    SQL
    parse_all(result)
  end


  def self.all
    # execute a SELECT; result in an `Array` of `Hash`es, each
    # represents a single row.
    results = DBConnection.instance.execute('SELECT * FROM owners')
    results.map { |result| Owner.new(result) }
  end

  def self.create(owner_name, owner_rating)
    # in this example, we'll only allow new rows to be created; never
    # modified.
    raise 'already saved!' unless self.id.nil?

    # execute an INSERT; the '?' gets replaced with the value name. The
    # '?' lets us separate SQL commands from data, improving
    # readability, and also safety (lookup SQL injection attack on
    # wikipedia).
    DBConnection.instance.execute(<<-SQL, owner_name, owner_rating)
      INSERT INTO
        owners (owner_name, owner_rating)
      VALUES
        (?, ?)
    SQL

    @id = DBConnection.instance.last_insert_row_id
  end

end
