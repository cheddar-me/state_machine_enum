# StateMachineEnum

This concern adds a method called "state_machine_enum" useful for defining an enum using string values along with valid state transitions. Validations will be added for the state transitions and a proper enum is going to be defined. For example:

```ruby
state_machine_enum :state do |states|
  states.permit_transition(:created, :approved_pending_settlement)
  states.permit_transition(:approved_pending_settlement, :rejected)
  states.permit_transition(:created, :rejected)
  states.permit_transition(:approved_pending_settlement, :settled)
end
```

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add state_machine_enum

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install state_machine_enum

## Usage

StateMachineEnum needs to be extended and then it could be used, as example in AR model.

```
class User < ApplicationRecord
  include StateMachineEnum

  state_machine_enum :state do |s|
    s.permit_transition(:registered, :active)
    s.permit_transition(:active, :banned)
    s.permit_transition(:banned, :active)
    s.permit_transition(:active, :deleted)
  end
end
```

And then it will offer bunch of convenient methods and callbacks that ensure proper state transitions.

```
user = User.new(state: 'registered')
user.active?
user.registered! # throws InvalidState error, because state can not transition to "registered".
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cheddar-me/state_machine_enum.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
