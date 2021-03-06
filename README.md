# Sapp
![build-tatus](https://travis-ci.org/hayduke19us/sapp.svg?branch=functional_version)

Sapp is a simple application framework for [Rack]( http://rack.github.io/ ).
It simplifies the routing process by handling route matching early on.

### Architecture

**Module::Class( Mixins )**

- Sapp
	- Base( Resources, Routes )
	- Router
	- RouteMap
    - Path
		- Base
		- Request
	- Handler
	- Response

## Installation

Add this line to your application's Gemfile:

```ruby

gem 'sapp'

```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sapp

## Examples

[Sapp with SimpleSession]( http://github.com/hayduke19us/sapp_test )

## Usage

Sapp is meant to be sublcassed.

``` ruby

class UserEndpoints < Sapp::Base

  routes go here...

end

```

### Routes
There are a few different ways to declare routes.

Sinatra style blocks:

```ruby

  get '/users' do
    'All users'
  end

```

Rails style CRUD methods:

```ruby

  index 'users' do
    'Get all users'
  end

  show 'user' do
    'Get a user'
  end

  update 'user' do
    'Patch a user'
  end

  create 'user' do
    'Post a new user'
  end

  delete 'user' do
    'Delete a user'
  end

```

Rails style resources:
Declaring a route with resources defines a route in Sapp::RouteMap.routes. 
However the Proc handling the response is empty. 

```ruby

  resources 'user'

```

To update the response add CRUD methods.

```ruby

  resources 'user'

  index 'users' do
    'All users'
  end

```

Direct Mapping:

```ruby

  route 'GET', '/users' do
    'Get all users'
  end

  add 'GET', '/users' do
    `Get all users`
  end

```

Name spacing and opinionated nesting:

```ruby

  namespace 'user'
  
  # '/user/:id' 
  
  get '/:id' do 

	'One User'
  
  end

  # /user/posts/:id

  namespace 'posts', nest: true

  get '/:id' do 

	'One Post'
  
  end

```

Root:

```ruby 

  # Declare the root like a normal route 
  
  get '/' do 

	"This is root"
  
  end
  
  # Declare the root with a simple method and block
  
  root do 
  
	"This is root"

  end

```




### Response Body
The response may be a **String**, **Hash**, or **Array**

- String: returns string.
- Hash: returns Json object.
- Array: returns array *must be a rack tuple*

**Rack tuple:**

```ruby

  [status, {headers}, [ body ]]

```

```ruby
   
  get '/users' do
    "Get all users" 
  end

  # Returns: [ 200, {}, [ 'Get all users' ]] 

  get '/users' do
    [ 200, {}, ['Get all users' ]]
  end

  # Returns: [ 200, {}, [ 'Get all users' ]]

  get '/users' do
    { name: frank, height: 6.1 }
  end

  # Returns: [ 200, {}, [ "{\"name\":\"frank\",\"height\":6.1}" ]]

```

### Set status:

```ruby

  get '/users' do
    set_status 200
  end

```

### Params
Params is a Hash storing body params and url symbol values. 
It serves the same purpose regardless of the request method. 
Access params normally. 

```ruby

  # Expects body params { name: 'a name', height: 6.1 }
  post '/user', do
    name   = params[:name]
    height = params[:height]
  end

  get '/user/:id', do
    id = params[:id]
  end

```
  
### Multiple Applications 

If you intend on using multiple Controllers for routing use the Sapp::Router.
Initialize Sapp::Router in config.ru or in a seperate file that represents your
routes. 

```ruby 

# users.rb

require  'sapp'

class Users < Sapp::Base 

  resources 'users'

  index 'users' do 
    
	'All Users'

  end

end

# posts.rb

class Posts < Sapp::Base 

  resources 'post'

  index 'posts' do 
    
	'All Posts'

  end

end

end

#config.ru 

use RackcommonLogger

app = Sapp::Router.new do 

  create Users 

  create Posts

end

run app

```
  
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sapp. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

