require 'test_helper'

class SappTest < Minitest::Test

  def setup
    @klass = Sapp::Base
  end

  def test_that_it_has_a_version_number
    refute_nil ::Sapp::VERSION
  end

  def test_routes_is_a_hash
    assert_equal Hash, @klass.routes.class
  end

  def test_sapp_has_methods_with_RESTful_verb_names
    verbs = %w(get post put patch delete)
    verbs.each do |v|
      assert @klass.singleton_methods.include?(v.to_sym), "missing :#{v} method"
    end
  end

  def test_verb_methods_take_path_and_handler_and_stores_in_routes_hash
    @klass.get '/foo' do
      'Hello Mr. Foo'
    end

    handler = @klass.routes['GET']['foo'][:paths].first[:handler]
    assert handler
    assert_equal "Hello Mr. Foo", handler.call, "Handler should be  a Proc"
  end

end
