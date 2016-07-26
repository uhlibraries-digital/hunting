class Repository

  attr_reader :collections
  attr_accessor :size

  def self.scout(aliases = 'all')
    Repository.new(aliases)
  end

  def initialize(aliases)
    @progressbar = Hunting.progressbar('repository', Hunting.config[:cdm]['name'])
    @size = 0
    @collections = scout(aliases)
    @progressbar.finish
  end

  def scout(aliases)
    collections = {}
    collection_info = {}
    cdm_collection_data = JSON.parse(open(Hunting.config[:dmwebservices] + "dmGetCollectionList/json").read)

    cdm_collection_data.each do |collection|
      collection_info.store(collection['secondary_alias'], {:alias => collection['secondary_alias'], :name => collection['name']})
    end

    if aliases == 'all'
      collection_info.each do |collection_alias, info|
        collections.store(collection_alias, Collection.new({:alias => collection_alias, :name => info[:name]}))
      end
    else
      aliases.each do |c_alias|
        collections.store(c_alias, Collection.new({:alias => c_alias, :name => collection_info[c_alias][:name]}))
      end
    end
    collections.each {|c_alias, collection| @size += collection.size}
    collections
  end
end
