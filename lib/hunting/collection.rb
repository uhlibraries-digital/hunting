class Collection

  attr_reader :alias,
              :title,
              :long_title,
              :data,
              :size,
              :labels,
              :metadata_map,
              :objects

  def initialize(collection, repository)
    @alias = collection[:alias]
    @title = collection[:title]
    @long_title = collection[:long_title]
    @cdm_url = repository[:cdm_url]
    @repository_metadata_map = repository[:metadata_map]
    @labels = map_labels_to_nicks
    @metadata_map = map_metadata
    @size = 0
    @data = scout_cdm
    @objects = {}
  end

  def map_labels_to_nicks
    labels = {}
    field_info = JSON.parse(open(@cdm_url + "dmGetCollectionFieldInfo/#{@alias}/json").read)
    field_info.each { |field| labels.store(field['name'], field['nick']) }
    labels
  end

  def map_metadata
    collection_map = {}
    field_map = {}
    @labels.each do |label, nick|
      field_map = @repository_metadata_map.fetch(label)
      collection_map.store(nick, field_map)
    end
    # contentdm metadata fields
    collection_map.store('dmaccess', { :namespace => 'cdm', :map => 'dmAccess', :type => nil, :vocab => nil})
    collection_map.store('dmimage', { :namespace => 'cdm', :map => 'dmImage', :type => nil, :vocab => nil})
    collection_map.store('restrictionCode', { :namespace => 'cdm', :map => 'restrictionCode', :type => nil, :vocab => nil})
    collection_map.store('cdmfilesize', { :namespace => 'cdm', :map => 'fileSize', :type => nil, :vocab => nil})
    collection_map.store('cdmfilesizeformatted', { :namespace => 'cdm', :map => 'fileSizeFormatted', :type => nil, :vocab => nil})
    collection_map.store('cdmprintpdf', { :namespace => 'cdm', :map => 'printPDF', :type => nil, :vocab => nil})
    collection_map.store('cdmhasocr', { :namespace => 'cdm', :map => 'hasOCR', :type => nil, :vocab => nil})
    collection_map.store('cdmisnewspaper', { :namespace => 'cdm', :map => 'isNewspaper', :type => nil, :vocab => nil})
    collection_map.store('dmaccess', { :namespace => 'cdm', :map => 'dmAccess', :type => nil, :vocab => nil})
    collection_map.store('dmimage', { :namespace => 'cdm', :map => 'dmImage', :type => nil, :vocab => nil})
    collection_map.store('restrictionCode', { :namespace => 'cdm', :map => 'restrictionCode', :type => nil, :vocab => nil})
    collection_map.store('cdmfilesize', { :namespace => 'cdm', :map => 'fileSize', :type => nil, :vocab => nil})
    collection_map.store('cdmfilesizeformatted', { :namespace => 'cdm', :map => 'fileSizeFormatted', :type => nil, :vocab => nil})
    collection_map.store('cdmprintpdf', { :namespace => 'cdm', :map => 'printPDF', :type => nil, :vocab => nil})
    collection_map.store('cdmhasocr', { :namespace => 'cdm', :map => 'hasOCR', :type => nil, :vocab => nil})
    collection_map.store('cdmisnewspaper', { :namespace => 'cdm', :map => 'isNewspaper', :type => nil, :vocab => nil})
    collection_map
  end

  def scout_cdm
    data = {}
    records = Hunting.config[:cdm]['records']
    raw_data = JSON.parse(open(@cdm_url + "dmQuery/#{@alias}/0/title/title/#{records}/1/0/0/0/0/0/0/json").read)
    raw_data['records'].each do |record|
      data.store(record['pointer'], {:filetype => record['filetype'], :title => record['title']})
      Hunting.increment
      @size += 1
    end
    data
  end

  def trap(pointer)
    if @data.has_key?(pointer)
      @progressbar = Hunting.progressbar('object', "#{@title}(#{pointer})")
      digital_object = DigitalObject.new({:cdm_url => @cdm_url},
                                         {:labels => @labels, :alias => @alias, :progress => 'no'},
                                         {:pointer => pointer, :type => @data[pointer][:filetype]})
      @progressbar.finish
      digital_object
    else
    end
  end

  def hunt(pointers = 'all')
    if pointers == 'all'
      @progressbar = Hunting.progressbar('collection', @title, @size)
      @data.each do |pointer, object|
        @objects.store(pointer, DigitalObject.new({:cdm_url => @cdm_url},
                                                  {:labels => @labels, :alias => @alias, :progress => 'yes'},
                                                  {:pointer => pointer, :type => object[:filetype]}))
      end
      @progressbar.finish
    else
      @progressbar = Hunting.progressbar('collection', @title, pointers.size)
      pointers.each do |pointer|
        if @data.has_key?(pointer)
          @objects.store(pointer, DigitalObject.new({:cdm_url => @cdm_url},
                                                    {:labels => @labels, :alias => @alias, :progress => 'yes'},
                                                    {:pointer => pointer, :type => @data[pointer][:filetype]}))
        end
      end
      @progressbar.finish
    end
  end
end
