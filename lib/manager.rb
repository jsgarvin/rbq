module RBQ
  class Manager
    include Singleton
    class << self
      attr_reader :playlist
    
      def set_path(path)
        Library.setup(path)
        Playlist.setup(path)
      end
      
      def build_new_queue
        Playlist.clear
        while Playlist.hours < 8 and Library.total_weight > 0
          new_song = Library.pick_a_song
          unless Playlist.songs.include?(new_song)
            Playlist.add_songs(new_song)
          end
        end
        Playlist.spread(25)
        Playlist.save
      end
    end
  end
end