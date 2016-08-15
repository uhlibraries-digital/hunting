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
    @metadata = {}
    @items = {}
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
    @labels.each do |label, nick|
      if raw_metadata[nick] == {}
        @metadata[label] = ''
      else
        @metadata[label] = raw_metadata[nick]
      end
    end
    if @type == 'compound'
      get_c_o_info = "dmGetCompoundObjectInfo/#{@alias}/#{@pointer}/xml"
      c_o_data = XmlSimple.xml_in(open(Hunting.config[:dmwebservices] + get_c_o_info))
      if c_o_data['page'] == nil
        content = open(Hunting.config[:dmwebservices] + get_c_o_info) {|f| f.read}
        doc = XmlSimple::Document.new content
        doc.elements.each("cpd/node/*") {|hierarchy| flatten(hierarchy)}
      else
        c_o_data['page'].each do |page|
          @items.store(page['pageptr'][0].to_i, DigitalObject.new({:pointer => page['pageptr'][0].to_i, :type => 'file'},
                                                                  {:labels => @labels, :alias => @alias}))
        end
      end
    end
  end

  def flatten(hierarchy)
    if hierarchy.elements['pageptr'] == nil
      hierarchy.elements.each {|node| flatten(node)}
    else
      pointer = hierarchy.elements['pageptr'].text.to_i
      @items.store(pointer, DigitalObject.new({:pointer => pointer, :type => 'file'},
                                              {:labels => @labels, :alias => @alias}))
    end
  end
end