module RBQ
  class Manager
    include Singleton
    class << self
      attr_reader :playlist
    
      def set_path(path)
        Library.setup(path)
        @playlist = Playlist.new(path)
      end
      
      def build_new_queue
        playlist.clear
        while playlist.hours < 8 and Library.total_weight > 0
          new_song = Library.pick_a_song
          unless playlist.songs.include?(new_song)
            playlist.add_songs(new_song)
          end
        end
        playlist.spread(25)
        playlist.save
      end
    end
  end
end