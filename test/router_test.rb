require 'test_helper'
require 'mocks/app'

class RouterTest < Minitest::Test
  include Rack::Test::Methods

  def app
    @app ||= Sapp::Router.new do
      create Mocks::App
      create Mocks::Resources
    end
  end

  def test_App
    get '/foo'
    assert_equal 200, last_response.status
  end

  def test_Resources
    get '/users'
    assert_equal 200, last_response.status
  end

  def test_not_found_is_returned_if_no_path_is_found
    get '/not_here_i_promise'
    assert_equal 404, last_response.status
  end

  def test_replicate_routes_raise_a_warning_but_run_by_order_found
    @app = Sapp::Router.new do
      create Mocks::Resources
      create Mocks::Crud
    end

    assert_output(/duplicate/) do
      get '/users'
      assert_equal 200, last_response.status
    end

  end

end
