module Mocks
  class App < Sapp::Base

    get '/foo' do
      [200, {}, ["Hello"]]
    end

    post '/foo' do
      [200, {}, [params]]
    end

    patch '/bar' do
      [200, {}, [params]]
    end

    get '/json' do
      { name: 'pete', height: 6.1, hair: 'black' }
    end

    get '/status' do
      set_status params["status"]
      "the status should be set to #{params}"
    end

    get '/foo/:id' do 
      "This should return a user"
    end

  end

  class Resources < Sapp::Base

    resources "user"

  end

  class Crud < Sapp::Base

    index "users" do
      "All Users"
    end

    show "user" do
      "One User"
    end

  end

  class ResourcesAndCrud < Sapp::Base

    resources "user"

    index "users" do
      "All Users"
    end

    show "user" do
      "One User"
    end

  end

  class ComplexRoute < Sapp::Base
    resources "user"

    get '/user/:id/posts/:post_id/:date/:limit/words/:start' do
      params
    end
  end

  class AliasRoute < Sapp::Base
    add 'GET', '/users/this_is_add'
    route 'POST', '/users/this_is_route'
  end

  class Namespace < Sapp::Base
    namespace 'users', 'posts'
    get '/:id' do
      "Returns all a users posts"
    end

    namespace 'posts', 'users'
    get '/:id' do
      "Returns all posts users"
    end

    namespace 'friends', nest: true
    get '/:id' do
      "Returns a posts user's friend"
    end

  end

  class NestedNamespace < Sapp::Base
    namespace 'posts', 'users'
    get '/:id/articles/:id/:time' do
      "Returns all articles"
    end

    namespace 'words', nest: true
    get '/:limit/:date/:time' do
      "Returns all words"
    end

  end

  class Root < Sapp::Base

    root do
      "Root"
    end

    get '/not_root' do
      'Not Root'
    end
  end
end
