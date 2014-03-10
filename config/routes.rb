Cms::Engine.routes.draw do
  get "page/css" => "page#css"
  get "page/js"  => "page#js"
  get "page/"           => "page#index"  
  get "page/:column"    => "page#index"
  post "page/:column"   => "page#index"
  get "page/:column/:child_column/:id" => "page#index"
  post "page/:column/:child_column/:id" => "page#index"
  get "page/:column/:child_column" => "page#index"
  post "page/:column/:child_column" => "page#index"    

    get "setting/show"
    get "setting/modify"
    patch "setting/modify"
    resources :categories
    resources :columns
    resources :functions
    resources :feedbacks
    resources :infos
    resources :templates
    resources :themes        
    resources :sites    
end