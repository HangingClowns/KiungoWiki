class ArtistWikiLink < WikiLink
  include Mongoid::Document

  set_reference_class Artist
  cache_attributes :name, :surname, :given_name, :birth_date, :birth_location

  def name(exclude_role=false)
    if artist
      case
        when !self.surname.blank? && !self.given_name.blank?
          self.surname + ", " + self.given_name
        when !self.surname.blank?
          self.surname
        when !self.given_name.blank?
          self.given_name
        else
          self.name
      end
    else
      self.objectq
    end #+ ((role.blank? || exclude_role) ? "" : " [#{self.role}]")
  end

  def object_text
    text = [self.name.to_s]

    unless self.birth_date.blank? && self.birth_location.blank?
      birth_text = []
      birth_text << self.birth_date.year unless self.birth_date.blank?
      birth_text << self.birth_location unless self.birth_location.blank?

      text << "(" + birth_text.join(", ") + ")"
    end

    text.join(" ")
  end

  class SearchQuery < ::SearchQuery 
    def self.query_expressions
      superclass.query_expressions.merge({surname: :text,
        given_name: :text,
        name: :text,
        birth_date: :date,
        birth_location: :text,
        death_date: :date,
        death_location: :text,
        info: :text 
      })
    end
    def self.catch_all
      "name"
    end 
 #   def self.meta_fields
 #     super + [:role]
 #   end
  end
end

#        role: :text,
#       relation: :text
