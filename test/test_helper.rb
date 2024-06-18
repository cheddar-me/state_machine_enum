# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "state_machine_enum"

require "minitest/autorun"
require "active_support"
require "active_support/test_case"
require "active_record"

class ActiveSupport::TestCase
  def setup
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    ActiveRecord::Schema.define do
      create_table :users, force: true do |t|
        t.string :state, default: "registered"
      end
    end
  end

  def teardown
    ActiveRecord::Base.connection.disconnect!
  end
end
