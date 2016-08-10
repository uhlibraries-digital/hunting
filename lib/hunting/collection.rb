class Collection

  attr_reader :alias,
              :name,
              :labels,
              :size,
              :records,
              :objects

  def initialize(collection)
    @alias = collection[:alias]
    @name = collection[:name]
    @labels = map_labels_to_nicks
    @size = 0
    @records = scout_cdm
    @objects = {}
  end

  def map_labels_to_nicks
    labels = {}
    get_field_info = "dmGetCollectionFieldInfo/#{@alias}/json"
    field_info = JSON.parse(open(Hunting.config[:dmwebservices] + get_field_info).read)
    field_info.each { |field| labels.store(field['name'], field['nick']) }
    labels
  end

  def scout_cdm
    data = {}
    records = Hunting.config[:cdm]['records']
    dm_query = "dmQuery/#{@alias}/0/title/title/#{records}/1/0/0/0/0/0/0/json"
    raw_data = JSON.parse(open(Hunting.config[:dmwebservices] + dm_query).read)
    raw_data['records'].each do |record|
      data.store(record['pointer'], {:filetype => record['filetype'], :title => record['title']})
      Hunting.increment
      @size += 1
    end
    data
  end

  def trap(pointer)
    if @records.has_key?(pointer)
      @progressbar = Hunting.progressbar('object', "#{@alias}(#{pointer})")
      digital_object = DigitalObject.new({:pointer => pointer, :type => @records[pointer][:filetype]},
                                         {:labels => @labels, :alias => @alias, :progress => 'no'})
      @progressbar.finish
      digital_object
    else
      puts "'#{@alias}' trap #{pointer} failed"
    end
  end

  def hunt(pointers = 'all')
    not_found = []
    if pointers == 'all'
      @progressbar = Hunting.progressbar('collection', @alias, @size)
      @records.each do |pointer, object|
        @objects.store(pointer, DigitalObject.new({:pointer => pointer, :type => object[:filetype]},
                                                  {:labels => @labels, :alias => @alias, :progress => 'yes'}))
      end
      @progressbar.finish
    else
      @progressbar = Hunting.progressbar('collection', @alias, pointers.size)
      pointers.each do |pointer|
        if @records.has_key?(pointer)
          @objects.store(pointer, DigitalObject.new({:pointer => pointer, :type => @records[pointer][:filetype]},
                                                    {:labels => @labels, :alias => @alias, :progress => 'yes'}))
        else
          not_found.push(pointer)
        end
      end
      @progressbar.finish
      if not_found.size > 0
        print "'#{@alias}' hunt failed for: "
        not_found.each {|object| print "#{object} "}
        print "(#{not_found.size} of #{pointers.size})\n"
      end
    end
  end
end
