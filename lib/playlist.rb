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
    
    def songs(range = nil)
      @songs ||= []
      return range ? @songs[range] : @songs 
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
    
    #spreads apart different tracks by the same artist so that
    #they have at least 'distance' other tracks between them
    def spread(distance, spread_counter = 0)
      had_to_spread = false
      songs.each do |song|
        sindex = songs.index(song)
        next if sindex == 0
        dst_ago = sindex < distance ? 0 : (sindex - distance)
        one_ago = sindex - 1
        if artists(dst_ago..one_ago).include?(song.artist)
          if  sindex < songs.size-1 
            s = songs.delete_at(sindex)
            songs.insert(sindex+1,s)
            had_to_spread = true
          else
            s = songs.delete_at(sindex)
          end
        end
      end
      spread(distance, spread_counter+1) if had_to_spread and spread_counter <= distance * 2
    end
    
    def artists(range = nil)
      songs(range).inject([]){|artists,song| artists << song.artist }
    end
    
    #######
    private
    #######
    
    def new_document(filename)
      Document.new(File.new(File.expand_path("#{@path}/#{filename}")))
    end
  end
end