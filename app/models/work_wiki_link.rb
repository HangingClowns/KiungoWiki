class WorkWikiLink
  include Mongoid::Document
  include WikiLink

  set_reference_class Work, WorkSearchQuery

  accepts_nested_attributes_for :work
  belongs_to :work, inverse_of: nil

  def title
    (self.work && self.work.title) ||self.objectq
  end

  def display_text
    self.title.to_s + (self.metaq.empty? ? "" : " (#{self.metaq})")
  end

  def date_written
    work.date_written if work
  end
end
