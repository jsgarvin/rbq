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
      @weight ||= (seconds_since_seen/(play_count+1)) * rating
    end
    
    def play_count=(c)
      @play_count = c.to_i
    end
    
    def duration=(d)
      @duration = d.to_i
    end
    
    def rating=(r)
      @rating = r.to_i
    end
    
    def seconds_since_seen
      (Time.now - first_seen).to_i 
    end
    
    def to_e
      e = Element.new('location')
      e.add_text self.location
      return e
    end
  end
end