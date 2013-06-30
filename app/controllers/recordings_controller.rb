class RecordingsController < ApplicationController

  # only registered users can edit this wiki
  before_filter :authenticate_user!, except: [:show, :index, :lookup, :portal, :recent_changes, :search, :alphabetic_index, :without_artist, :without_releases, :without_tags, :without_supplementary_sections]

  def index
    @recordings = build_filter_from_params(params, Recording.all.order_by(cache_normalized_title:1))

    respond_to do |format|
      format.xml { render xml: @recordings }
      format.json { render json: @recordings }
      format.html
    end
  end
  
  def without_artist
    @recordings = Recording.where("artist_wiki_links.artist_id" => nil).page(params[:page]).all
  end
  
  def without_releases
    @recordings = Recording.where("release_wiki_link.release_id" => nil).page(params[:page]).all
  end
  
  def without_tags
    @recordings = Recording.where(missing_tags: true).page(params[:page]).all
  end
  
  def without_supplementary_sections
    @recordings = Recording.where(missing_supplementary_sections: true).page(params[:page]).all
  end
  
  def recent_changes    
    redirect_to changes_path(scope: "recording")
  end

  def portal
    @feature_in_month = PortalArticle.where(category: "recording", :publish_date.lte => Time.now).order_by(publish_date:-1).first
    respond_to do |format|
      format.html 
    end      
  end

  def alphabetic_index
    @recordings = build_filter_from_params(params, Recording.where(cache_first_letter: params[:letter]).order_by(cache_normalized_title:1))
  end
  
  def show
    @recording = Recording.find(params[:id])
    if current_user
      @user_tags = @recording.user_tags.where(user:current_user).all
    end
    respond_to do |format|
      format.xml { render xml: @recording.to_xml(except: [:versions]) }
      format.json { render json: @recording }
      format.html
    end
  end

  def new
    unless params[:q]
      redirect_to search_recordings_path, alert: t("messages.recording_new_without_query")
    else
      @recording = Recording.new(work_wiki_link_text: params[:q])
      @supplementary_section = @recording.supplementary_sections.build
      respond_to do |format|      
        format.html # new.html.erb
        format.xml  { render xml: @recording }
      end
    end
  end

  def create
    @recording = Recording.new(params[:recording])

    respond_to do |format|
      puts @recording.to_xml
      if @recording.save
        format.html { redirect_to(@recording , :notice => 'Recording succesfully created.') }
        format.xml  { render :xml => @recording, :status => :created, :location => @recording }

      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @recording.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit 
    @recording = Recording.find(params[:id])
  end 

  def add_supplementary_section
    @recording = Recording.find(params[:id])
    @recording.add_supplementary_section
    respond_to do |format|      
      format.html { render :action => "edit" }
      format.xml  { render :xml => @recording }
    end
  end 

  def update
    @recording = Recording.find(params[:id])

    respond_to do |format|
      if @recording.update_attributes(params[:recording])
        format.html { redirect_to(@recording, notice: "Recording succesfully updated.") }
        format.xml  { render xml: @recording, status: :ok, location: @recording }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @recording.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @recording = Recording.find(params[:id])
    
    @recording.destroy
    respond_to do |format|
      format.html { redirect_to(recordings_url) }
      format.xml  { head :ok }
    end
  end

  def lookup
    wiki_link_klass = { "artist"=>ArtistRecordingWikiLink, 
                        "release"=>ReleaseRecordingWikiLink,
                        "work"=>WorkRecordingWikiLink }[params[:src]] || RecordingWikiLink

    rsq = wiki_link_klass.search_query(params[:q])

    respond_to do |format|
      format.json { 
        render :json=>(Recording.queried(rsq.objectq).limit(20).collect{|r| 

          wiki_link_klass.new(reference_text: "oid:#{r.id} #{rsq.metaq}").combined_link

        } << {id: params[:q].to_s, name: params[:q].to_s + " (nouveau)"}) 
      }
    end
  end

  protected
  def filter_params
    {
      q: lambda {|recordings, params| recordings.queried(params[:q]) }
    }
  end

  def build_filter_from_params(params, recordings)

    filter_params.each {|param_key, filter|
      puts "searching using #{param_key} with value #{params[param_key]}"
      recordings = filter.call(recordings,params) if params[param_key]
    }

    recordings = recordings.page(params[:page])

    recordings
  end
end
