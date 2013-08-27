KiungoWiki::Application.routes.draw do

  get 'user_tags/lookup' => 'user_tags#lookup', format: :json

  resources :possessions

  resources :changes

  resources :portal_articles

  resources :users, only: :index

  devise_for :users

  resources :labels, only: :index do
    collection do
      get 'lookup'
    end
  end
  
  resources :works do
    collection do
      get 'lookup'
      get 'portal'
      get 'letter_:letter', action: "alphabetic_index", as: :alphabetic
      get 'recent_changes' #, :action=>"recent_changes", :recent_changes=>1, :as=>:recent_changes
      get 'search'
      get 'without_artist'
      get 'without_recordings'
      get 'without_lyrics'
      get 'without_tags'
      get 'without_supplementary_sections'
    end
    member do
      put 'user_tags' => 'user_tags#update', format: :json
      get 'add_supplementary_section'
    end
  end

  resources :artists do
    collection do
      get 'lookup'
      get 'portal'
      get 'letter_:letter', action: "alphabetic_index", as: :alphabetic
      get 'recent_changes' #, :action=>"recent_changes", :recent_changes=>1, :as=>:recent_changes
      get 'search'
      get 'list'
      get 'without_work'
      get 'without_recordings'
      get 'without_releases'
      get 'without_supplementary_sections'
    end
    member do
      put 'user_tags' => 'user_tags#update', format: :json
      get 'add_supplementary_section'
    end
  end

  resources :releases do
    collection do
      get 'lookup'
      get 'portal'
      get 'letter_:letter', action: "alphabetic_index", as: :alphabetic
      get 'recent_changes' #, :action=>"recent_changes", :recent_changes=>1, :as=>:recent_changes
      get 'search'
      get 'without_artist'
      get 'without_recordings'
      get 'without_supplementary_sections'
    end
    member do
      put 'user_tags' => 'user_tags#update', format: :json
      get 'add_supplementary_section'
    end
  end
  
  resources :recordings do
    collection do
      get 'lookup'
      get 'portal'
      get 'letter_:letter', action: "alphabetic_index", as: :alphabetic
      get 'recent_changes' #, :action=>"recent_changes", :recent_changes=>1, :as=>:recent_changes
      get 'search'
      get 'without_artist'
      get 'without_releases'
      get 'without_tags'
      get 'without_supplementary_sections'
    end
    member do
      put 'user_tags' => 'user_tags#update', format: :json
      get 'add_supplementary_section'
    end
  end

  resources :categories do
    collection do
      get 'lookup'
      get 'search'
    end
  end

  match 'search' => 'search#index'
  match 'site_plan' => "home#site_plan"

  root to: "home#index"
end
