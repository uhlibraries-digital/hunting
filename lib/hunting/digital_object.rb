class DigitalObject

  attr_reader :pointer,
              :type,
              :title,
              :metadata,
              :items

  def initialize(repository, collection, record)
    @pointer = record[:pointer]
    @cdm_url = repository[:cdm_url]
    @alias = collection[:alias]
    @labels = collection[:labels]
    case record[:type]
    when 'cpd'
      @type = 'compound'
      Hunting.increment if collection[:progress] == 'yes'
    when 'file'
      @type = 'file'
    else
      @type = 'single'
      Hunting.increment if collection[:progress] == 'yes'
    end
    get_item_info = "dmGetItemInfo/#{@alias}/#{@pointer}/json"
    raw_metadata = JSON.parse(open(@cdm_url + get_item_info).read)
    @title = raw_metadata['title']
    @metadata = {}
    collection[:labels].each do |label, nick|
      if raw_metadata[nick] == '{}'
        @metadata[label] = ''
      else
        @metadata[label] = raw_metadata[nick]
      end
    end
    if @type == 'compound'
      @items = {}
      compound_object_info = "dmGetCompoundObjectInfo/#{@alias}/#{@pointer}/xml"
      compound_object_data = Nokogiri::XML(open(@cdm_url + compound_object_info)).xpath('//pageptr/text()')
      compound_object_data.each do |pointer|
        @items.store(pointer.to_s.to_i, DigitalObject.new({:cdm_url => @cdm_url},
                                                          {:labels => @labels, :alias => @alias},
                                                          {:pointer => pointer.to_s.to_i, :type => 'file'}))
      end
    else
      @items = nil
    end
  end
end