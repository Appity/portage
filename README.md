# Portage

This is a bridge between a thread pool for long-running or blocking operations
and an [Async](https://github.com/socketry/async) reactor. Each of the
operations is wrapped in an Async::Task which will wait until the operation is
completed.

If an exception occurs within the task, the Async::Task should receive it and
raise it as normal, no special handling required.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'portage'
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install portage
```

## Usage

Within an Async application:

```ruby
Async do
  # Initialize the ThreadPool when Task.current is defined
  pool = Portage::ThreadPool.new

  pool.task do
    # Some blocking task
  end.wait
end

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tadman/portage. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/tadman/portage/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Portage project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/tadman/portage/blob/master/CODE_OF_CONDUCT.md).
