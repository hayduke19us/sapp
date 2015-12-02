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

end

class SampleApp2 < Sapp::Base

  get '/foo' do
    [200, {}, ["Hello"]]
  end

  post '/foo' do
    [200, {}, [params]]
  end

end


class BaseTest < Minitest::Test
  include Rack::Test::Methods

  def app
    @app || SampleApp
  end

  def test_we_can_make_a_request
    get '/foo'
    assert last_response
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

  focus
  def test_if_the_response_is_a_hash_change_the_content_type_accordingly 
    get '/json'
    assert_equal 'application/json', last_response.headers["Content-Type"]
  end
end
