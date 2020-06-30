require_relative '../../lib/active_record_base.rb'
require_relative '../../db/db_connection'

class Creation < SQLObject
  attr_accessor :id, :owner_id, :creation_name, :creation_rating

  belongs_to :owner

  self.table_name = 'creations'

  def initialize(options = {})
    @id = options['id']
    @owner_id = options['owner_id']
    @creation_name = options['creation_name']
    @creation_rating = options['creation_rating']
  end


  def self.all
    # execute a SELECT; result in an `Array` of `Hash`es, each
    # represents a single row.
    results = DBConnection.instance.execute('SELECT * FROM creations')
    results.map { |result| Creation.new(result) }
  end

  def self.create(owner_id, creation_name, creation_rating)
    # in this example, we'll only allow new rows to be created; never
    # modified.
    raise 'already saved!' unless self.id.nil?

    # execute an INSERT; the '?' gets replaced with the value name. The
    # '?' lets us separate SQL commands from data, improving
    # readability, and also safety (lookup SQL injection attack on
    # wikipedia).
    DBConnection.instance.execute(<<-SQL, owner_id, creation_name, creation_rating)
      INSERT INTO
        creations (owner_id, creation_name, creation_rating)
      VALUES
        (?, ?, ?)
    SQL

    @id = DBConnection.instance.last_insert_row_id
  end

end
