class Recording 
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search

#TODO: Re-enable some form of versioning most likely using https://github.com/aq1018/mongoid-history instead of the Mongoid::Versioning module

  before_save :set_cached_attributes

  field :title, :type => String
  field :recording_date, :type => IncDate
  field :recording_location, :type => String
  field :duration, :type => Duration
  field :rythm, :type => Integer
  field :category_id, :type => Integer
  field :origrecordingid, :type => String
  field :info, :type => String, :default => ""

  search_in :title, {:match => :all}
  
#  validates_length_of :work_title, :in=>1..500, :allow_nil=>true
#  validates_numericality_of :duration, :greater_than=>0, :allow_nil=>true  
#  validates_format_of :recording_date_text, :with=>/^(\d{4})(?:-?(\d{0,2})(?:-?(\d{0,2}))?)?$/, :allow_nil=>true
  validates_numericality_of :rythm, :greater_than=>0, :allow_nil=>true

  embeds_one :work_wiki_link, :as=>:linkable
  validates_associated :work_wiki_link  
  accepts_nested_attributes_for :work_wiki_link

  embeds_many :artist_wiki_links, :as=>:linkable
  accepts_nested_attributes_for :artist_wiki_links
  validates_associated :artist_wiki_links

  embeds_many :album_wiki_links, :as=>:linkable
  accepts_nested_attributes_for :album_wiki_links
  validates_associated :album_wiki_links

  def work_title
    self.work_wiki_link.display_text
  end

  def album_title
    self.album_wiki_link.title 
  end

  def work_wiki_link_text
    (work_wiki_link && work_wiki_link.reference_text) || ""
  end

  def work_wiki_link_combined_link
    work_wiki_link && [work_wiki_link.combined_link]
  end

  def work_wiki_link_text=(value)
    self.work_wiki_link = WorkWikiLink.new({:reference_text=>value})
  end

  def artist_wiki_links_text
    artist_wiki_links.collect{|v| v.reference_text }.join(",")
  end

  def artist_wiki_links_combined_links
    artist_wiki_links.collect{|v| v.combined_link }
  end

  def artist_wiki_links_text=(value)
    self.artist_wiki_links.each{|a| a.destroy} #TODO find a way to do it at large since the self.artist_wiki_links.clear does not work
    value.split(",").each{|q| 
      self.artist_wiki_links.build(:reference_text=>q.strip) 
    }    
  end

  def album_wiki_links_text
    album_wiki_links.collect{|v| v.reference_text }.join(",")
  end

  def album_wiki_links_combined_links
    album_wiki_links.collect{|v| v.combined_link }
  end

  def album_wiki_links_text=(value)
    self.album_wiki_links.each{|a| a.destroy} #TODO find a way to do it at large since the self.album_wiki_links.clear does not work
    value.split(",").each{|q| 
      self.album_wiki_links.build(:reference_text=>q.strip) 
    }    
  end

  def category
    unless["0","",nil].include?(self.category_id)
      Category.where(:category_id => self.category_id).first.category_name
    else
      "unknown"
    end
  end
  
  scope :queried, ->(q) {
    current_query = all
    rsq = RecordingSearchQuery.new(q)
    rsq.filled_query_fields.each {|field|
      case field
        when :title
          current_query = current_query.csearch(rsq[field])
        when :info
          current_query = current_query.where(field=>/#{rsq[field].downcase}/i)
        when :created_at, :duration, :recording_date, :rythm, :update_at
          current_query = current_query.where(field=>rsq[field])        
      end 
    }
    current_query
  }

  private 
  def set_cached_attributes
    self.title = self.work_title
  end
end
