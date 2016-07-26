class DigitalObject

  attr_reader :pointer,
              :type,
              :title,
              :metadata,
              :items

  def initialize(record, collection)
    @pointer = record[:pointer]
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
    raw_metadata = JSON.parse(open(Hunting.config[:dmwebservices] + get_item_info).read)
    @title = raw_metadata['title']
    @metadata = {}
    collection[:labels].each do |label, nick|
      if raw_metadata[nick] == {}
        @metadata[label] = ''
      else
        @metadata[label] = raw_metadata[nick]
      end
    end
    if @type == 'compound'
      @items = {}
      get_c_o_info = "dmGetCompoundObjectInfo/#{@alias}/#{@pointer}/xml"
      c_o_data = XmlSimple.xml_in(open(Hunting.config[:dmwebservices] + get_c_o_info))
      c_o_data['page'].each do |page|
        @items.store(page['pageptr'][0].to_i, DigitalObject.new({:pointer => page['pageptr'][0].to_i, :type => 'file'},
                                                                {:labels => @labels, :alias => @alias}))
      end
    else
      @items = nil
    end
  end
end