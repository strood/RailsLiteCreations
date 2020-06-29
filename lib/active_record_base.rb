require_relative "../db/db_connection.rb"
require "active_support/inflector"

class SQLObject

  def initialize(params = {})
    # Iterate through each of the k,v pairs, convery k to sym and see if in columns, if not error
    # set the attribute if no error, using send.
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym
      if self.class.columns.include?(attr_name)
        self.send("#{attr_name}=", value)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end
  end

  def self.columns
    # return an array of symbols, corrospnding to the columns in our db table
    return @columns if @columns

    cols = DBConnection.execute2(<<-SQL).first
    SELECT
      *
    FROM
      "#{self.table_name}"
    SQL

    @columns = cols[0].map(&:to_sym)
  end

  def self.finalize!
    # Adds getter and setter methods for each column
    # Called at end of the subclass definition to add the getters/setters
    # Use columns to list all comumn names, then like attr_accessor, we do getter and setters for each

    self.columns.each do |name|
      define_method(name) do
        self.attributes[name]
      end
      define_method("#{name}=") do |value|
        self.attributes[name] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= "#{self}".tableize
  end

  def self.all
    # fetch all recods from database.Parse them with pase_all to get in correct format
    # return @records if @records

    db_return = DBConnection.execute(<<-SQL)
    SELECT
      #{table_name}.*
    FROM
      #{table_name}
    SQL

    parse_all(db_return)
  end

  def self.parse_all(results)
    # take raw array of hash objects, and convert them into the class type thatis currently being
    # called on
    results.map { |el| self.new(el) }
  end

  def self.find(id)
    # instead of using self.all and Array.find on the return, do a new SQP request that only
    # pulls the specific col we are looking for based on id
    db_return = DBConnection.execute(<<-SQL, id)
    SELECT
      #{table_name}.*
    FROM
      #{table_name}
    WHERE
      #{table_name}.id = ?
    SQL

    parse_all(db_return).first
  end


  def attributes
    # Return a hash of all our models columns, and values
    # lazily initialize it as an empty hash in case it doesnt exist.
    @attributes ||= {}
  end

  def attribute_values
    # called in insert DB execute, returns the valus of each attribute of our class instance
    #This will be passd back in qith splat opertor to go to our SQL query
    self.class.columns.map { |col| self.send("#{col}") }
  end

  def insert
    # Insewrt a value into db
    col_names = self.class.columns.join(", ")
    question_marks = ["?"] * self.class.columns.length
    question_marks = question_marks.join(", ")

    DBConnection.execute(<<-SQL, *self.attribute_values)
    INSERT INTO
      #{self.class.table_name} (#{col_names})
    VALUES
      (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    # update a records attributes, similar to insert ^

    set_line = self.class.columns.map { |col| "#{col} = ?" }.join(", ")

    DBConnection.execute(<<-SQL, *self.attribute_values, self.id)
    UPDATE
      #{self.class.table_name}
    SET
      #{set_line}
    WHERE
      id = ?
    SQL
  end

  def where(params)
    # search for our specific cat baes in params passed in as hash
    where_line = params.each_key.map { |key| "#{key} = ?" }.join(" AND ")

    db_return = DBConnection.execute(<<-SQL, *params.values)
    SELECT
      *
    FROM
      #{table_name}
    WHERE
      #{where_line}
    SQL

    parse_all(db_return)
  end

  def save
    # calls insert if record does not exist, update if already existing.
    if self.id
      self.update
    else
      self.insert
    end
  end
end
