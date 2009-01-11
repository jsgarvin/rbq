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
        $stdout.sync = true
        Playlist.clear
        while Playlist.hours < 8 and Library.total_weight > 0
          new_song = Library.pick_a_song
          unless Playlist.songs.include?(new_song)
            Playlist.add_songs(new_song)
          end
          print "\rBuilding Playlist: #{((Playlist.hours/8)*100).to_i}%"
        end
        puts "\rBuilding Playlist: 100%"
        Playlist.spread(25)
        Playlist.save
      end
    end
  end
end