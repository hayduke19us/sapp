require 'test_helper'
require 'mocks/app.rb'
require 'rack/test'
require 'json'


class BaseTest < Minitest::Test
  include Rack::Test::Methods

  def app
    @app || Mocks::App
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
    @app = Mocks::Resources
    get '/users'
    assert_equal "Placeholder", last_response.body
  end

  def test_can_define_routes_with_CRUD_methods_and_block
    @app = Mocks::Crud
    get '/users'
    assert_equal "All Users" , last_response.body
  end

  def test_using_CRUD_methods_overrides_the_handler
    @app = Mocks::ResourcesAndCrud
    get '/users'
    assert_equal "All Users" , last_response.body
  end

  focus
  def test_if_a_request_path_is_not_found_a_404_is_returned
    @app = Mocks::Crud
    get '/users/:id/what'
    assert_equal 404, last_response.status
  end

end
