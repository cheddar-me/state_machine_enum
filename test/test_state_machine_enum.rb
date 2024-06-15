# frozen_string_literal: true

require "test_helper"

class TestStateMachineEnum < ActiveSupport::TestCase
  class User < ActiveRecord::Base
    include StateMachineEnum

    state_machine_enum :state do |s|
      s.permit_transition(:registered, :active)
      s.permit_transition(:active, :banned)
      s.permit_transition(:banned, :active)
      s.permit_transition(:active, :deleted)
    end
  end

  def test_state_transitions
    u = User.create!

    assert u.active!
    assert u.banned!
    assert u.active!
    assert u.deleted!
  end

  def test_callbacks
    u = User.create!

    assert u.active!
    error = assert_raises(ActiveRecord::RecordInvalid) { u.registered! }
    assert_equal("Validation failed: State Invalid transition from active to registered", error.message)

    error = assert_raises(ArgumentError) { u.update!(state: "missing") }
    assert_equal("'missing' is not a valid state", error.message)
  end

  def test_ensure_state_may_transition_to!
    u = User.create!(state: "active")

    assert_nil u.ensure_state_may_transition_to!(:banned)

    assert_raises(StateMachineEnum::InvalidState) { u.ensure_state_may_transition_to!("active") }
    error = assert_raises(StateMachineEnum::InvalidState) { u.ensure_state_may_transition_to!(:active) }
    assert_equal("state already is \"active\"", error.message)

    error = assert_raises(StateMachineEnum::InvalidState) { u.ensure_state_may_transition_to!(:registered) }
    assert_equal("state may not transition from \"active\" to :registered", error.message)
  end

  def test_ensure_state_one_of!
    u = User.create!(state: "active")

    assert_nil u.ensure_state_one_of!(:active, :banned)
    assert_nil u.ensure_state_one_of!("active", "banned")

    error = assert_raises(StateMachineEnum::InvalidState) { u.ensure_state_one_of!(:banned, :deleted) }
    assert_equal("state must be one of [:banned, :deleted] but was \"active\"", error.message)

    error = assert_raises(StateMachineEnum::InvalidState) { u.ensure_state_one_of!("banned", "deleted") }
    assert_equal("state must be one of [\"banned\", \"deleted\"] but was \"active\"", error.message)
  end

  def test_may_transition_to?
    u = User.create!

    assert u.active!

    assert u.state_may_transition_to?(:banned)
    assert u.state_may_transition_to?("banned")
    refute u.state_may_transition_to?(:registered)
    refute u.state_may_transition_to?(:missing)
  end
end
