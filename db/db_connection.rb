require 'sqlite3'

PRINT_QUERIES = ENV['PRINT_QUERIES'] == 'true'
# https://tomafro.net/2010/01/tip-relative-paths-with-file-expand-path
ROOT_FOLDER = File.join(File.dirname(__FILE__), '..')
# Toggle these for different DB names
CREATIONS_SQL_FILE = File.join(ROOT_FOLDER, 'creations.sql')
CREATIONS_DB_FILE = File.join(ROOT_FOLDER, 'creations.db')
# ADDED AS WORKAROUND TO COMMENTING OUT CODE IN self.reset
# false = no reset when server started/stopped
# true = any creations you saved to db will be reset on server shutdown/reset
RESET_DB_ON_SHUTDOWN = false

class DBConnection
  def self.open(db_file_name)
    @db = SQLite3::Database.new(db_file_name)
    @db.results_as_hash = true
    @db.type_translation = true

    @db
  end

  def self.reset
    # Did have these lines in that would wipe the server each time i shut it down
    # Included workaround for persistance above, toggle global var for persistance
    # not sure what calls reset, believe puma, but was unable to find another workaround.
    commands = [
      "rm '#{CREATIONS_DB_FILE}'",
      "cat '#{CREATIONS_SQL_FILE}' | sqlite3 '#{CREATIONS_DB_FILE}'"
    ]
    # Only reset server on shutdown if specified in global
    if RESET_DB_ON_SHUTDOWN
      commands.each { |command| `#{command}` }
    end

    DBConnection.open(CREATIONS_DB_FILE)
  end

  def self.instance
    reset if @db.nil?

    @db
  end

  def self.execute(*args)
    print_query(*args)
    instance.execute(*args)
  end

  def self.execute2(*args)
    print_query(*args)
    instance.execute2(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end

  private

  def self.print_query(query, *interpolation_args)
    return unless PRINT_QUERIES

    puts '--------------------'
    puts query
    unless interpolation_args.empty?
      puts "interpolate: #{interpolation_args.inspect}"
    end
    puts '--------------------'
  end
end
