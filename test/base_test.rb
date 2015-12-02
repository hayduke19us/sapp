require 'test_helper'
require 'rack/test'
require 'json'

class SampleApp < Sapp::Base

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

class SampleApp2 < Sapp::Base

  get '/foo' do
    [200, {}, ["Hello"]]
  end

  post '/foo' do
    [200, {}, [params]]
  end

end

class SampleApp3 < Sapp::Base

  resources "user"

end

class SampleApp4 < Sapp::Base

  index "users" do
    "All Users"
  end

  show "user" do
    "One User"
  end

end

class SampleApp5 < Sapp::Base

  resources "user"

  index "users" do
    "All Users"
  end

  show "user" do
    "One User"
  end

end


class BaseTest < Minitest::Test
  include Rack::Test::Methods

  def app
    @app || SampleApp
  end

  def test_GET
    get '/foo'
    assert last_response
  end

  def test_GET_with_url_params
    skip
    get 'foo/2'
    assert_equal 1, last_response
  end

  def test_post
    post '/foo', name: 'frank'
    refute last_response.body.empty?
  end

  def test_app_routes
    assert_equal 3, app.routes.count
  end

  def test_that_routes_can_change
    @app = SampleApp2
    assert_equal 2, app.routes.count
  end

  def test_if_the_response_body_is_a_hash_change_to_json_for_client
    get '/json'
    assert JSON.parse(last_response.body)
  end

  def test_if_the_response_is_a_hash_change_the_content_type_accordingly 
    get '/json'
    assert_equal 'application/json', last_response.headers["Content-Type"]
  end

  def test_can_set_the_status_from_within_the_handler
    get '/status', status: '999'
    assert_equal 999, last_response.status
  end

  def test_can_define_routes_with_resources
    @app = SampleApp3
    get '/users'
    assert_equal "Placeholder", last_response.body
  end

  def test_can_define_routes_with_CRUD_methods_and_block
    @app = SampleApp4
    get '/users'
    assert_equal "All Users" , last_response.body
  end

  def test_using_CRUD_methods_overrides_the_handler
    @app = SampleApp5
    get '/users'
    assert_equal "All Users" , last_response.body
  end

end
