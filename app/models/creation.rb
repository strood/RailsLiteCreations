require_relative '../../lib/active_record_base.rb'
require_relative '../../db/db_connection'

class Creation < SQLObject
  attr_accessor :name, :owner_name, :id
  self.table_name = 'creations'

  def initialize(options = {})
    @id = options['id']
    @name = options['name']
    @owner_name = options['owner_name']
  end


  def self.all
    # execute a SELECT; result in an `Array` of `Hash`es, each
    # represents a single row.
    results = DBConnection.instance.execute('SELECT * FROM creations')
    results.map { |result| Creation.new(result) }
  end

  def self.create(name, owner_name)
    # in this example, we'll only allow new rows to be created; never
    # modified.
    raise 'already saved!' unless self.id.nil?

    # execute an INSERT; the '?' gets replaced with the value name. The
    # '?' lets us separate SQL commands from data, improving
    # readability, and also safety (lookup SQL injection attack on
    # wikipedia).
    DBConnection.instance.execute(<<-SQL, name, owner_name)
      INSERT INTO
        creations (name, owner_name)
      VALUES
        (?, ?)
    SQL

    @id = DBConnection.instance.last_insert_row_id
  end

end
