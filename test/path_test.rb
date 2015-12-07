require 'test_helper'

class PathTest < Minitest::Test
  def setup
    @path = Sapp::Path::Base.new("/users/:id")
  end

  def test_sanity
    assert_equal "/users/:id", @path.original
  end

  def test_extract_paths_and_keys
    @path.extract_keys_and_paths
    assert_equal "users", @path.paths[0]
    assert_equal ":id", @path.keys[1]
  end

  def test_if_key_is_before_path
    build_complex_path

    assert_equal ":id", @path.keys[0]
    assert_equal "users", @path.paths[1]
  end

  def test_if_consecutive_paths
    build_complex_path

    assert_equal "get.something", @path.paths[2]
    assert_equal "really", @path.paths[3]
  end

  def test_if_consecutive_ids
    build_complex_path

    assert_equal ":weird", @path.keys[4]
    assert_equal ":ok", @path.keys[5]
  end

  def test_parse_extracts_and_merges_keys_and_paths
    path = @path.parse
    assert_equal "users", path[:controller]
    assert_equal ":id", path[:keys][1]
  end

  def test_if_a_path_is_added_with_a_symbol_raise_argument_error
    path = Sapp::Path::Base.new("/:id/what_is_this")
    assert_raises ArgumentError do
      path.parse
    end
  end

  def test_if_namespaces_options_is_given_it_is_added_to_path_hash
    options = {options: { namespaces: [["users"]] }}

    path = Sapp::Path::Base.new("/namespace", options)
    assert_equal 'users', path.parse[:namespaces].flatten.first
  end

  private

  def build_complex_path
    uri  = "/:id/users/get.something/really/:weird/:ok" 
    @path = Sapp::Path::Base.new uri
    @path.extract_keys_and_paths
  end

end

class PathRequestTest < Minitest::Test
  def setup
    @new_proc = Proc.new {"Hey hey"}
    @map = Sapp::RouteMap.new
    @map.add "GET", "/users/:id", &@new_proc
    @path = Sapp::Path::Request.new("/users/3", "GET", @map.routes)
  end

  def test_create_stream_creates_a_numerically_keyed_hash_for_path
    assert_equal "users",  @path.sort_path[0]
  end

  def test_parse_sets_controller
    @path.parse
    assert_equal 'users', @path.controller
  end

  def test_find_controller_returns_the_routes_for_that_countroller
    @path.parse
    assert_equal Proc, @path.handler.class
    assert_equal '3', @path.keys[:id]
  end

  def test_no_path_is_found
    path = Sapp::Path::Request.new("/not_found/3", "GET", @map.routes)
    path.parse
    refute path.path?
  end

  def test_creating_a_root_path
    path = Sapp::Path::Base.new("/")
    path.parse
    assert_equal '/', path.controller
  end

end
