module RBQ
  class Library
    include REXML
    attr_reader :songs
    
    def initialize(path)
      @path = path
      @songs = []
      $stdout.sync = true
      doc = new_document('rhythmdb.xml')
      counter = 0
      total = doc.root.get_elements("entry[@type='song']").size
      doc.root.each_element_with_attribute('type', 'song') do |el|
        @songs << Song.new(
          :title => get_element_value(el,:title),
          :artist => get_element_value(el,:artist),
          :duration => get_element_value(el,:duration),
          :location => get_element_value(el,:location),
          :rating => get_element_value(el,:rating),
          :play_count => get_element_value(el,'play-count'),
          :last_played => get_element_value(el,'last-played')
        )
        counter += 1
        print "\rLoading Library: #{((counter.to_f/total)*100).to_i}%"
      end
      puts
    end
    
    def total_weight
      songs.inject(0) {|total,song| total + song.weight }
    end
    
    def pick_a_song
      target = rand(total_weight)
      counter = 0
      songs.each do |song|
        counter += song.weight
        return song if counter >= target
      end
    end
    
    #######
    private
    #######
    def new_document(filename)
      Document.new(File.new(File.expand_path("#{@path}/#{filename}")))
    end
    
    def get_element_value(element,key)
      element.elements[key.to_s] ? element.elements[key.to_s].text : nil
    end
  end
end