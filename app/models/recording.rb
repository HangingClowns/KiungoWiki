class Recording
  include Mongoid::Document
  field :recording_date, :type => DateTime
  field :recording_location, :type => String
  field :duration, :type => Integer
  field :rythm, :type => Integer
  
  validates_presence_of :duration
end
