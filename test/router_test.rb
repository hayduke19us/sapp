require 'test_helper'
require 'mocks/app'

class RouterTest < Minitest::Test
  include Rack::Test::Methods

  def app
    @app = Sapp::Router.new do
      create Mocks::App
      create Mocks::Resources
    end
  end

  def test_App
    get '/foo'
    assert_equal 200, last_response
  end

  focus
  def test_Resources
    get '/users'
    assert_equal 200, last_response.status
  end


end
