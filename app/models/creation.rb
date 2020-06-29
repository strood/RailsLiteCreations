require_relative '../../lib/active_record_base.rb'
require_relative '../../db/db_connection'

class Creation < SQLObject
  self.table_name = 'creations'

  def initialize(options = {})
    @id = options['id']
    @name = options['name']
    @owner_name = options['owner_name']
  end


  def self.all
    # execute a SELECT; result in an `Array` of `Hash`es, each
    # represents a single row.
    results = CreationDatabase.instance.execute('SELECT * FROM creations')
    results.map { |result| Creation.new(result) }
  end

  def self.create
    # in this example, we'll only allow new rows to be created; never
    # modified.
    raise 'already saved!' unless self.id.nil?

    # execute an INSERT; the '?' gets replaced with the value name. The
    # '?' lets us separate SQL commands from data, improving
    # readability, and also safety (lookup SQL injection attack on
    # wikipedia).
    CreationDatabase.instance.execute(<<-SQL, name)
      INSERT INTO
        creations (name)
      VALUES
        (?)
    SQL

    @id = CreationDatabase.instance.last_insert_row_id
  end

end
