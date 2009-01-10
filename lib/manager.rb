module RBQ
  class Manager
    attr_reader :library, :playlist
    
    def initialize(path)
      @library = Library.new(path)
      @playlist = Playlist.new(path)
    end
    
    def build_new_queue
      playlist.clear
      while playlist.hours < 1 and library.total_weight > 0
        new_song = library.pick_a_song
        unless playlist.songs.include?(new_song)
          playlist.add_songs(new_song)
          puts "Added: #{new_song.title} / #{new_song.artist} / #{playlist.hours}"
        end
      end
      playlist.save
    end
    
  end
end