module RBQ
  class Playlist
    include REXML
    attr_reader :doc
      
    def initialize(path)
      @path = path
      @doc = new_document('playlists.xml')
    end
    
    def clear
      queue.elements.each do |el|
        queue.delete_element(el)
      end
    end
    
    def queue
      doc.root.elements["playlist[@type='queue']"]
    end
    
    def save
      songs.each do |song|
        queue.add_element song.to_e
      end
      File.open(File.expand_path("#{@path}/playlists.xml"),'w') {|out| out << doc.to_s }  
    end
    
    def songs
      @songs ||= []
    end
    
    def add_songs(s)
      @songs += [s].flatten
      s.weight = 0
    end
  
    def shuffle
      @songs = songs.sort_by { rand }
    end
    
    def hours
      (songs.inject(0) {|seconds,song| seconds + song.duration.to_i }).to_f/3600
    end
    
    
    #######
    private
    #######
    
    def new_document(filename)
      Document.new(File.new(File.expand_path("#{@path}/#{filename}")))
    end
  end
end