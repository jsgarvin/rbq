require 'rexml/document'
require 'singleton'
require 'lib/library'
require 'lib/common'

module RBQ
  class Playlist
    include Singleton
    
    class << self
      include SharedLibraryPlaylistMethods
      attr_accessor :filename
      
      def path=(p); Library.path = path; end
      def path; Library.path; end
      def filename; @filename ||= 'playlists.xml'; end
      
      def clear
        queue.elements.each do |el|
          queue.delete_element(el)
        end
      end
      
      def queue
        xml_doc.root.elements["playlist[@type='queue']"]
      end
      
      def save
        songs.each do |song|
          queue.add_element song.location_element
        end
        File.open(File.expand_path("#{path}/playlists.xml"),'w') {|out| out << xml_doc.to_s }  
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
        (songs.inject(0) {|seconds,song| seconds + song.duration }).to_f/3600
      end
      
      #spreads apart different tracks by the same artist so that
      #they have at least 'distance' other tracks between them
      def spread(distance, spread_counter = 0)
        $stdout.sync = true
        print spread_counter == 0 ? 'Spreading: ' : ':'
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
              print '.'
            else
              s = songs.delete_at(sindex)
              print '-'
            end
          end
        end
        spread(distance, spread_counter+1) if had_to_spread and spread_counter <= distance * 2
        puts if spread_counter == 0
      end
      
      def artists(range = nil)
        songs(range).inject([]){|artists,song| artists << song.artist }
      end
     
    end
  end
end