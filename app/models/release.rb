class Release
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::History::Trackable

  field :title, type: String
  field :date_released, type: IncDate
  field :label, type: String
  field :media_type, type: String
  field :reference_code, type: String
  field :number_of_recordings, type: Integer
  field :origalbumid, type: String

  #
  # calculated values so we can index and sort
  #
  field :cache_normalized_title, type: String, default: ""
  field :cache_first_letter, type: String, default: ""

  before_save :update_cached_fields

  index({ cache_normalized_title: 1 }, { background: true })
  index({ cache_first_letter: 1, cache_normalized_title: 1 }, { background: true })

  search_in :title, :label, {match: :all}

  validates_presence_of :title

  embeds_many :artist_wiki_links, as: :linkable, class_name: "ReleaseArtistWikiLink"
  accepts_nested_attributes_for :artist_wiki_links
  validates_associated :artist_wiki_links

  embeds_many :recording_wiki_links, as: :linkable, class_name: "ReleaseRecordingWikiLink"
  accepts_nested_attributes_for :recording_wiki_links
  validates_associated :recording_wiki_links

  embeds_many :supplementary_sections, class_name: "SupplementarySection"
  accepts_nested_attributes_for :supplementary_sections
  validates_associated :supplementary_sections
  
  has_many :possessions

  # telling Mongoid::History how you want to track changes
  track_history   modifier_field: :modifier, # adds "referenced_in :modifier" to track who made the change, default is :modifier
                  version_field:  :version,   # adds "field :version, :type => Integer" to track current version, default is :version
                  track_create:     true,    # track document creation, default is false
                  track_update:     true,     # track document updates, default is true
                  track_destroy:    true     # track document destruction, default is false


  def artist_wiki_links_text
    artist_wiki_links.collect{|v| v.reference_text }.join(",")
  end

  def artist_wiki_links_combined_links
    artist_wiki_links.collect{|v| v.combined_link }
  end

  def artist_wiki_links_text=(value)
    self.artist_wiki_links.reverse.each{|a| a.destroy} #TODO find a way to do it at large since the self.artist_wiki_links.clear does not work
    value.split(",").each{|q| 
      self.artist_wiki_links.build(reference_text: q.strip) 
    }    
  end

  def first_artist_display_text
    self.artist_wiki_links.first && self.artist_wiki_links.first.display_text
  end
  
  def recording_wiki_links_text
    recording_wiki_links.collect{|v| v.reference_text }.join(",")
  end

  def recording_wiki_links_combined_links
    recording_wiki_links.collect{|v| v.combined_link }
  end

  def recording_wiki_links_combined_links_renamed
    mappings = {title: :name}
    recording_wiki_links_combined_links.collect do |x|
      Hash[x.map {|k,v| [mappings[k] || k, v] }]
    end
  end

  def recording_wiki_links_text=(value)
    self.recording_wiki_links.reverse.each{|a| a.destroy} #TODO find a way to do it at large since the self.recording_wiki_links.clear does not work
    value.split(",").each{|q| 
      self.recording_wiki_links.build(reference_text: q.strip) 
    }    
  end

  def add_supplementary_section
    self.supplementary_sections << SupplementarySection.new()
  end

  def normalized_title
    self.title.to_s.
      mb_chars.
      normalize(:kd).
      to_s.
      gsub(/[._:;'"`,?|+={}()!@#%^&*<>~\$\-\\\/\[\]]/, ' '). # strip punctuation
      gsub(/[^[:alnum:]\s]/,'').   # strip accents
      downcase.strip
  end

  def title_first_letter
    first_letter = self.normalized_title[0] || ""
    first_letter = "#" if ("0".."9").include?(first_letter)
    first_letter
  end

  def update_cached_fields
    self.cache_normalized_title = self.normalized_title
    self.cache_first_letter = self.title_first_letter
  end

  def to_wiki_link
    ReleaseWikiLink.new(reference_text: "oid:#{self.id}", release: self)
  end
  
  scope :queried, ->(q) {
    current_query = all
    asq = ReleaseWikiLink.search_query(q)
    asq.filled_query_fields.each {|field|
      case field
        when :title
          current_query = current_query.csearch(asq[field], match: :all)
        when :label, :media_type, :reference_code
          current_query = current_query.where(field=>/#{asq[field].downcase}/i)
        when :date_released, :created_at, :updated_at
          current_query = current_query.where(field=>asq[field])        
      end 
    }
    current_query
  }


  #Release.all.group_by {|a| a.title_first_letter.upcase }.sort{|a, b| a <=> b}.each {|a| puts "* [" + a[0] + "] - " + a[1][0..4].collect{|b| "[" + b.title + "]"}.join(", ") + (a[1][5] ? ", [...]": "") }; nil
  #Release.all.group_by {|a| a.date_released.year.to_s }.sort{|a, b| a <=> b}.each {|a| puts "* [" + a[0] + "] - " + a[1][0..4].collect{|b| "[" + b.title + "]"}.join(", ") + (a[1][5] ? ", [...]": "") }; nil
  #Release.all.group_by {|a| a.date_released.year.to_s }.sort{|a, b| a <=> b}.each {|a| puts "" + a[0] + ", " + a[1].length.to_s }; nil
end