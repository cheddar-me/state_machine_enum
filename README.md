# StateMachineEnum

This concern adds a method called "state_machine_enum".
Useful for defining an enum using string values along with valid state transitions.
Validations will be added for the state transitions and a proper enum is going to be defined.

For example:
```ruby
state_machine_enum :state do |states|
  states.permit_transition(:created, :approved_pending_settlement)
  states.permit_transition(:approved_pending_settlement, :rejected)
  states.permit_transition(:created, :rejected)
  states.permit_transition(:approved_pending_settlement, :settled)
end
```

## Installation

Install the gem and add it to the application's Gemfile by executing:

    $ bundle add state_machine_enum

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install state_machine_enum

## Usage

StateMachineEnum needs to be included and then it could be used, for example, in an ActiveRecord model.
```ruby
class User < ApplicationRecord
  include StateMachineEnum

  state_machine_enum :state, prefix: :state do |s|
    s.permit_transition(:registered, :active)
    s.permit_transition(:active, :banned)
    s.permit_transition(:banned, :active)
    s.permit_transition(:active, :deleted)
  end
end
```

It then will offer a bunch of convenient methods and callbacks that ensure proper state transitions.
Note the prefix here to prefix the method. This is optional of course.

```ruby
user = User.new(state: 'active')
# with the prefix: :state
user.state_active?  # => true
# or without the prefix: :state
user.active? # => true

# The transition check happens when updating the state like this
user.update!(state: :registered)
# or when using the shortcut (add state_ because we have prefix: :state above)
user.state_registered!
```
The last command throws an InvalidState error: Invalid transition from active to registered
This is because the state was not permitted to transition back to "registered" from "active".
If you do want this, `s.permit_transition(:active, :registered)` should be added.

# Methods


## after_inline_transition_to?(to)
Runs the block inside `after_inline_transition_to` as a before_save action.
For example the state updates to :registered, but before the model is saved
```ruby
state_machine_enum :state, prefix: "state" do |s|
    s.permit_transition(:registered, :active)
    s.after_inline_transition_to(:registered) do |model|
        model.another_attr = Time.now.utc
    end
end
```
`another_attr` is automatically set to the current utc time.

## after_committed_transition_to(to)
Runs the block inside `after_committed_transition_to` as an after_commit action.
For example if you want to do something after it has committed to the database when the state is
updated to :registered
```ruby
state_machine_enum :state, prefix: "state" do |s|
    s.permit_transition(:registered, :active)
    s.after_committed_transition_to(:registered) do |model|
        model.send_notification!
    end
end
```

## after_any_committed_transition
Runs together with all the `after_committed_transition_to` hooks.
For example if you want to do something after any state update has commited.
```ruby
state_machine_enum :state, prefix: "state" do |s|
    s.permit_transition(:registered, :active)
    s.permit_transition(:active, :suspended)
    s.after_any_committed_transition_to do |model|
        log_changes!
    end
end

```

## Ensure methods
With a couple of ensure methods we can check beforehand for valid state transitions without actually having to do
the state transition.

## ensure_###_one_of!(state1, state2, etc)
E.g. seen from the previous examples, calling `ensure_state_one_of!(:registered, :active, :fake)`
will raise an InvalidState error because :fake is not present in state enum.

## ensure_###_may_transition_to!(to)
Calling `ensure_state_may_transition_to!(:active)` when the state is currently in :suspended
will raise an InvalidState error because we did not permite the transition from :active to :suspended.

## ###_may_transition_to?(from, to)
Predicate to check if a transition is possible with the rules we've set.
```ruby
state_machine_enum :state, prefix: "state" do |s|
    s.permit_transition(:registered, :active)
end

state_may_transition_to?(:registered, :active) # => true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cheddar-me/state_machine_enum.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
