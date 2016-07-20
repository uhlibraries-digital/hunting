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

```ruby
require 'hunting'
```

### Configuration
Hunting requires configuration for local CONTENTdm system attributes, collections, and metadata fields.

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
  :progressbar => { 'length' => 60 },
  :collections => [
                    { 'alias' => 'coll1',
                      'title' => 'collection_1',
                      'long_title' => 'Collection One'},
                    { 'alias' => 'coll2',
                      'title' => 'collection_2',
                      'long_title' => 'Collection Two'}
                  ],
  :metadata_map => [
                      { 'label' => 'Title',
                        'namespace' => 'dc',
                        'map' => 'title',
                        'type' => nil,
                        'vocab' => nil},
                      { 'label' => 'Creator (LCNAF)',
                        'namespace' => 'dcterms',
                        'map' => 'creator',
                        'type' => nil,
                        'vocab' => 'lcnaf'},
                      { 'label' => 'Subject.Topical (AAT)',
                        'namespace' => 'dcterms',
                        'map' => 'subject',
                        'type' => 'topic',
                        'vocab' => 'aat'}
                   ]
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

collections:
  - alias:      # CONTENTdm collection alias
    title:      # coll_title
    long_title: # Long Collection Title
  - alias:      # repeat for every collection
    title:
    long_title:

metadata_map:
  - label:      # CONTENTdm metadata field label
    namespace:  # mapping namespace (optional)
    map:        # mapping element (optional)
    type:       # category (optional)
    vocab:      # controlled vocabulary (optional)
  - label:      # repeat for every field
    namespace:
    map:
    type:
    vocab:
```

### Repository.scout

Scout the repository for objects in all collections.
```ruby
repo = Repository.scout
```

Scout the repository for objects in some collections.
```ruby
repo = Repository.scout(['collection_1_alias','collection_2_alias'])
```

Print some attributes of Collection 1.
```ruby
puts repo['collection_1_alias'].title
puts repo['collection_1_alias'].long_title
puts repo['collection_1_alias'].alias
puts repo['collection_1_alias'].size
```

Print the Title of Object 7 from Collection 1.
```ruby
puts repo['collection_1_alias'].data[7][:title]
```

Store all object pointers from Collection 1 in an array.
```ruby
collection_1_pointers = []
repo['collection_1_alias'].data.each do |pointer, attributes|
  collection_1_pointers.push(pointer)
end
```

### Collection.hunt

Hunt for all object metadata in Collection 1
```ruby
repo['collection_1_alias'].hunt
```

Hunt for some object metadata in Collection 1
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

