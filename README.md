# CapybaraNarrative

CapybaraNarrative is a page objects library for capybara. The goal is to provide a clean syntax that doesn't require learning very much of a new DSL and to primarily use the existing capybara syntax for tests. It's called 'narrative' because it allows pages that you visit to drive the narrative of your tests and puts the action at the start of each line as much as possible.

```
  home_page.visit do
    fill_form(search: 'Things that make ya go hmmm')
    click_on :search_button
  end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capybara_narrative'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install capybara_narrative

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/capybara_narrative. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/capybara_narrative/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CapybaraNarrative project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/capybara_narrative/blob/master/CODE_OF_CONDUCT.md).
