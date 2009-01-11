module RBQ
  class Song
    include REXML
    attr_accessor :title, :artist, :duration, :location, :rating, :play_count, :last_played, :first_seen, :weight
    
    def initialize(attrs = {})
      attrs.keys.each do |key|
        self.send("#{key}=",attrs[key])
      end
    end
    
    def last_played=(t)
      @last_played = t.is_a?(Time) ? t : Time.at(t.to_i)
    end
    
    def first_seen=(t)
      @first_seen = t.is_a?(Time) ? t : Time.at(t.to_i)
    end
    
    def weight
      @weight ||= seconds_since_played_or_seen * rating.to_i
    end
    
    def seconds_since_played_or_seen
      (Time.now - (last_played > first_seen ? last_played : first_seen))
    end
    
    def to_e
      e = Element.new('location')
      e.add_text self.location
      return e
    end
  end
end