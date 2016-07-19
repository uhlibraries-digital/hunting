require 'hunting/version'
require 'hunting/repository'
require 'hunting/collection'
require 'hunting/digital_object'
require 'yaml'
require 'json'
require 'nokogiri'
require 'open-uri'
require 'ruby-progressbar'

module Hunting
  # Configuration defaults
  @config = {
              :cdm => {
                        'name' => 'Default Repo',
                        'server' => 'repository.address.edu',
                        'port' => 42,
                        'download_dir' => 'path/to/download/dir',
                        'records' => 3000
                      },
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
                               ],
              :progressbar => { 'length' => 60 }
            }

  @valid_config_keys = @config.keys

  # Configure through hash
  def self.configure(opts = {})
    opts.each do |key,value|
      if @valid_config_keys.include? key.to_sym
        @config[key.to_sym] = value
      end
    end
  end

  # Configure through yaml file
  def self.configure_with(path_to_yaml_file)
    config = YAML::load(IO.read(path_to_yaml_file))
    configure(config)
  end

  def self.config
    @config
  end

  def self.progressbar(type, name, total = nil)
    length = Hunting.config[:progressbar]['length']
    case type
    when 'repository'
      @progressbar = ProgressBar.create(total: total,
                                        length: length,
                                        format: "Scouting #{name}: %c |%B|")
    when 'collection'
      @progressbar = ProgressBar.create(total: total,
                                        length: length,
                                        format: "Hunting #{name}: %c/%C |%B|")
    else
      @progressbar = ProgressBar.create(length: length,
                                        format: "Trapping #{name}")
    end
  end

  def self.increment
    @progressbar.increment
  end
end
