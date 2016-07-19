class Repository

  attr_reader :cdm_url,
              :base_url,
              :get_file_url,
              :download_dir,
              :log_dir,
              :collections,
              :metadata_map

  attr_accessor :size

  def self.scout(aliases = 'all')
    Repository.new(aliases)
  end

  def initialize(aliases)
    repository_name = Hunting.config[:cdm]['name']
    @progressbar = Hunting.progressbar('repository', repository_name)
    server = Hunting.config[:cdm]['server']
    port = Hunting.config[:cdm]['port']
    @cdm_url = "http://#{server}:#{port}/dmwebservices/index.php?q="
    @base_url = "http://#{server}"
    @get_file_url = "http://#{server}/contentdm/file/get/"
    @download_dir = Hunting.config[:cdm]['download_dir']
    @log_dir = File.join(@download_dir, 'logs')
    @size = 0
    @metadata_map = map_metadata
    @collections = scout(aliases)
    @progressbar.finish
  end

  def map_metadata
    metadata_map = {}
    Hunting.config[:metadata_map].each do |field|
      metadata_map.store(field['label'] , {:namespace => field['namespace'],
                                           :map => field['map'],
                                           :type => field['type'],
                                           :vocab => field['vocab']})
    end
    metadata_map
  end

  def scout(aliases)
    collections = {}
    info = {}
    Hunting.config[:collections].each do |collection|
      info.store(collection['alias'].to_sym, {:alias => collection['alias'],
                                              :title => collection['title'],
                                              :long_title => collection['long_title']})
    end
    if aliases == 'all'
      Hunting.config[:collections].each do |collection|
        collections.store(collection['alias'],
                          Collection.new(info[collection['alias'].to_sym],
                                        {:cdm_url => @cdm_url, :metadata_map => @metadata_map}))
      end
    else
      aliases.each do |collection_alias|
        collections.store(collection_alias,
                          Collection.new(info[collection_alias.to_sym],
                                        {:cdm_url => @cdm_url, :metadata_map => @metadata_map}))
      end
    end
    collections
  end
end
