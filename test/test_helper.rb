require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'test/unit'
require 'active_record'
require 'example_model'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

require 'sqlite_savepoint'

class ActiveSupport::TestCase
  
  def setup_db
    ActiveRecord::Schema.define(:version => 1) do
      create_table :example_models do |t|
      end
    end
  end
  
  def teardown_db
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.drop_table(table)
    end
  end
  
end
