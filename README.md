# Hunting

Hunting is a Ruby wrapper for the CONTENTdm API. Quickly 'Scout' for collections and objects in your Repository, 'Hunt' for metadata in your Collections, and 'Trap' individual Digital Objects.

## Installation

__This gem has not yet been published to RubyGems. Please use the Dev Installation instructions below after cloning the repository.__

Add this line to your application's Gemfile:

```ruby
gem 'hunting'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hunting

### Dev Installation

    $ bundle install
    $ gem build hunting.gemspec
    $ gem install .\hunting-0.1.0.gem

## Usage

```ruby
require 'hunting'
```

### Configuration
Hunting depends on configuration data, passed as either a hash or a yaml file, for local CONTENTdm system attributes, collections, and metadata fields.

#### With Hash
```ruby
Hunting.configure(hash)
```
Default config hash
```ruby
{
  :cdm => {
            'name' => 'Default Repo',
            'server' => 'repository.address.edu',
            'port' => 42,
            'download_dir' => 'path/to/download/dir',
            'records' => 3000
          },
  :progressbar => { 'length' => 60 }
}
```

#### With YAML File
```ruby
Hunting.configure_with('path\to\config.yml')
```

Example `config.yml`
```yaml
cdm:
  name:         # short repository name
  server:       # server address
  port:         # port number
  download_dir: # directory path for logs and files
  records:      # number of records to return for Collection.data

progressbar:
  length:       # integer width for progress bar (default: 60)
```

### Repository.scout

Scout the repository for objects in all collections.
```ruby
repo = Repository.scout
```

Print all collection aliases in the repository.
```ruby
repo.collections.each do |collection_alias, collection|
    puts collection_alias
end
```
OR
```ruby
repo.collections.each do |collection_alias, collection|
    puts collection.alias
end
```

Scout the repository for objects in some collections.
```ruby
repo = Repository.scout(['collection_1_alias','collection_2_alias'])
```

Print some attributes of Collection 1.
```ruby
puts repo.collections['collection_1_alias'].alias
puts repo.collections['collection_1_alias'].name
puts repo.collections['collection_1_alias'].size
```

Print the Title of Object 7 from Collection 1.
```ruby
puts repo.collections['collection_1_alias'].records[7][:title]
```

Store all object pointers from Collection 1 in an array.
```ruby
collection_1_pointers = []
repo.collections['collection_1_alias'].records.each do |pointer, record|
  collection_1_pointers.push(pointer)
end
```

### Collection.hunt

Hunt for all object metadata in Collection 1.
```ruby
repo.collections['collection_1_alias'].hunt
```

Hunt for some object metadata in Collection 1.
```ruby
repo.collections['collection_1_alias'].hunt([7,11,42])
```

Print the Title of Object 7 from Collection 1.
```ruby
puts repo.collections['collection_1_alias'].objects[7].metadata['Title']
```

Print the Title of Item 6 within (Compound) Object 7 from Collection 1.
```ruby
puts repo.collections['collection_1_alias'].objects[7].items[6].metadata['Title']
```

### Collection.trap

Trap Object 7 from Collection 1.
```ruby
object_7 = repo.collections['collection_1_alias'].trap(7)
```

Print some attributes of Object 7.
```ruby
puts object_7.metadata['Title']
puts object_7.type
puts object_7.pointer
```

Print all metadata field labels and values for Object 7.
```ruby
object_7.metadata.each do |label, value|
  puts "#{label}: #{value}"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/uhlibraries-digital/hunting.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

