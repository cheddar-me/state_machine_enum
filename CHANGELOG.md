## 0.1.4

* Raise `InvalidTransition` which is a subclass of `InvalidState`. That exception contains the following properties which can be used:
  * `attribute_name` is the name of the enum attribute
  * `from_state` is the state the transition was attempted from
  * `to_state` is the state the transition was going to
  * `already_in_target_state?` is `true` if a repeated transition was attempted
* Some more code styling
* Relax dependencies so that Bundler does not complain on Rails 8.x apps

## 0.1.3

* Added more documentation and improvements to the readme
* Little code styling

## 0.1.2

* Add basic tests
* `#ensure_<attribute>_may_transition_to!` now actually verifies that an attribute can transition to the new state.

## 0.1.1


* Provide real authors.

## 0.1.0

* Initial release
