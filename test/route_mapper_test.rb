require 'test_helper'

class RouteMapTest < Minitest::Test

  def setup
    @map = Sapp::RouteMap.new
    @map.add "GET", "/users", &@map.empty_proc
  end

  def test_is_initialized_with_routes_as_empty_hash
    assert @map.routes.empty?
  end

  focus
  def test_not_found_returns_a_tuple
    assert_equal 3, @map.not_found!.count
  end

  def test_you_can_add_routes_to_the_routes_hash
    @map.add "GET", "/users/:id", &@map.empty_proc
    assert @map.routes["GET"]["/users/:id"]
  end

  def test_you_can_remove_routes_from_hash_by_verb_removes_all
    @map.add "GET", "/users/:id", &@map.empty_proc
    @map.remove "GET"
    refute @map.routes["GET"]
  end

  def test_you_can_remove_routes_from_hash_by_path_and_verb
    @map.remove "GET", "/users"
    refute @map.routes["GET"]["/users"]
  end
end
