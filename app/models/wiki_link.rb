class  WikiLink
  include Mongoid::Document

  field :reference_text, default: ""
  embedded_in :linkable, polymorphic: true

  def reference_text=(value)
    self[:reference_text] = value
    sq = self.class.search_query(value)
    if sq[:oid]
      if self.referenced.nil? || self.referenced.id.to_s != sq[:oid]
        begin 
          self.referenced = self.class.referenced_klass.find(sq[:oid]) 
        rescue Mongoid::Errors::DocumentNotFound
          self.referenced = nil
        end
      end
    else
      self.referenced = nil
    end
  end

  def combined_link
    {id: self.reference_text.to_s, name: self.display_text}
  end 

  def referenced=(obj)
    self.send("#{self.class.reference_field}=".to_sym, obj)
  end
  def referenced
    self.send(self.class.reference_field.to_sym)
  end

  def searchref
    self.class.search_query(self.reference_text)
  end

  def metaq  
    self.searchref.metaq
  end
  def metaq=(text)
    self.reference_text = [self.objectq, text].join(" ")
  end

  def objectq  
    self.searchref.objectq
  end

  def object_text
    throw NotImplementedError
  end

  def display_text
    object_text + (self.metaq.blank? ? "" : " (#{self.metaq})")
  end

  def update_cached_attributes
    cached_attributes.each{|a|
      if referenced
        self.send("c_#{a}=".to_sym, referenced.send(a.to_sym))
      else
        self.send("c_#{a}=".to_sym, nil)
      end
    }
  end

  def flush_cached_attributes
    cached_attributes.each{|a| 
      self.unset(a.to_sym)
    }
  end

  def cached_attributes
    []
  end

  class << self

    def set_reference_class(klass)

      class_eval <<-EOM
        class << self
          def referenced_klass
            #{klass}
          end

          def reference_field
            "#{klass.to_s.downcase}"
          end
        end
      EOM


      belongs_to klass.to_s.downcase.to_sym, inverse_of: nil
      
    end

    def search_klass
      self::SearchQuery
    end

    def cache_attributes(*attributes)

      attributes_list = attributes.collect{|a| ":#{a}"}.join(", ")

      class_eval <<-EOM
        def cached_attributes          
          super + [#{attributes_list}]
        end
      EOM

      attributes.each{|a|

        options = {}
        [:type].each{|option|
          options[option] = referenced_klass.fields[a.to_s].options[option] if referenced_klass.fields[a.to_s].options[option]
        }

        field "c_#{a}".to_sym, options

        class_eval <<-EOM

          def #{a}
            self[:c_#{a}] ? c_#{a} : (referenced && referenced.#{a})
          end

        EOM
        
      }

#
# Don't enable it yet, the propagation mechanism is not in place
#
#      before_save :update_cached_attributes

    end

    def search_query(q)
      if self.respond_to?(:search_klass)
        self.search_klass.new(q)
      else
        self::SearchQuery.new(q)
      end
    end

  end # class << self

end


