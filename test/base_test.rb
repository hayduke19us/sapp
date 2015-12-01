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

  patch '/boo' do
    [200, {}, [params]]
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
end
