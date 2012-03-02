ElzarTest::Application.routes.draw do
  resource :lames do
    collection do
      get 'lame_index'
    end
  end
  root :to => 'lames#lame_index'
end
