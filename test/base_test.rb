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

  def test_if_a_request_path_is_not_found_a_404_is_returned
    @app = Mocks::Crud
    get '/users/:id/what'
    assert_equal 404, last_response.status
  end

  def test_a_very_complex_path_is_found
    @app = Mocks::ComplexRoute
    get '/user/2/posts/4/2015/10/words/frank'

    expected_params =  {
      'id' => '2',
      'post_id' => '4',
      'date' => '2015',
      'limit' => '10',
      'start' => 'frank'
    }

    assert_equal 200, last_response.status
    assert_equal expected_params, JSON.parse(last_response.body)
  end

  def test_add_functions_like_verb_or_resource_methods
    @app = Mocks::AliasRoute
    get '/users/this_is_add'
    assert_equal 200, last_response.status
  end

  def test_add_alias_route
    @app = Mocks::AliasRoute
    get '/users/this_is_add'
    assert_equal 200, last_response.status
  end

  def test_namespaces_are_cascading
    @app = Mocks::Namespace
    get '/users/posts/2'
    assert_equal 200, last_response.status
  end

  def test_namespaces_write_over_themselves
    @app = Mocks::Namespace
    get '/posts/users/2'
    assert_equal 200, last_response.status
  end

  focus
  def test_namespaces_can_be_used_for_nesting
    @app = Mocks::Namespace
    puts @app.routes
    get '/posts/users/2/friends'
    assert_equal 200, last_response.status
  end

end
