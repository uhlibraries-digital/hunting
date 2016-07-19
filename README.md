# Hunting

Hunting is a Ruby wrapper for the CONTENTdm API. Quickly 'Scout' for collections and objects in your Repository, 'Hunt' for metadata in your Collections, and 'Trap' individual Digital Objects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hunting'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hunting

### Dev Installation

    bundle install
    gem build hunting.gemspec
    gem install .\hunting-0.1.0.gem

## Usage

### Configuration
```ruby
require 'hunting'
Hunting.configure_with('path\to\config.yml')
```

### Repository.scout

Scout repository for objects in all collections
```ruby
repo = Repository.scout
```

Scout repository for objects in some collections
```ruby
repo = Repository.scout(['collection_1_alias','collection_2_alias'])
```

Print the Long Title of Collection 1
```ruby
puts repo['collection_1_alias'].long_title
```

Print the Title of Object 7 from Collection 1
```ruby
puts repo['collection_1_alias'].data[7][:title]
```

### Collection.hunt

Hunt for all object metadata in Collection 1
```ruby
repo['collection_1_alias'].hunt
```

Hunt for specific object metadata in Collection 1
```ruby
repo['collection_1_alias'].hunt([7,11,42])
```

Print the Title of Object 7 from Collection 1
```ruby
puts repo['collection_1_alias'].objects[7].metadata['Title']
```

Print the Title of Item 6 within (Compound) Object 7 from Collection 1
```ruby
puts repo['collection_1_alias'].objects[7].items[6].metadata['Title']
```

### Collection.trap

Trap Object 7 from Collection 1
```ruby
object_7 = repo['collection_1_alias'].trap(7)
```

Print some attributes of Object 7 from Collection 1
```ruby
object_7 = repo['collection_1_alias'].trap(7)
puts object_7.metadata['Title']
puts object_7.type
puts object_7.pointer
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hunting.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

