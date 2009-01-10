module RBQ
  class Manager
    attr_reader :library, :playlist
    
    def initialize(path)
      @library = Library.new(path)
      @playlist = Playlist.new(path)
    end
    
    def build_new_queue
      playlist.clear
      while playlist.hours < 8 and library.total_weight > 0
        new_song = library.pick_a_song
        unless playlist.songs.include?(new_song)
          playlist.add_songs(new_song)
        end
      end
      playlist.spread(25)
      playlist.save
    end
    
  end
end