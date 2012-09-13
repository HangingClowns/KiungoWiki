class AlbumRecordingWikiLink < RecordingWikiLink
  include Mongoid::Document

  def trackNb
    searchref[:trackNb]
  end

  def itemId
    searchref[:itemId]
  end

  def itemSection
    searchref[:itemSection]
  end

  class SearchQuery < RecordingWikiLink::SearchQuery 
    def self.query_expressions
      super.merge({ 
        trackNb: :numeric,
        itemId: :word,
        itemSection: :character      
      })
    end
    def self.meta_fields
      super + [:trackNb, :itemId, :itemSection]
    end
  end
end


