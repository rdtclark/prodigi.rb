# Prodigi API Rubygem

The easiest and most complete rubygem for [Prodigi](https://www.prodigi.com) . Currently supports [API v4](https://www.prodigi.com/print-api/docs/reference/#introduction).
 
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prodigi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install prodigi

## Usage

To access the API, you'll need to create a Prodigi::Client and pass in your API key. You can find your API key at https://dashboard.prodigi.com/settings/integrations

```ruby
client = Prodigi::Client:new(api_key: ENV["PRODIGI_API_KEY"])
```

The client then gives you access to each of the resources.

## Resources

The gem maps as closely as we can to the Prodigi API so you can easily convert API examples to gem code.

Responses are created as objects like Prodigi::Order. Having types like Prodigi::Quote is handy for understanding what type of object you're working with. They're built using OpenStruct so you can easily access data in a Ruby-ish way.

### Orders

```ruby
client.orders.list
client.orders.create({})
client.orders.retrieve(prodigi_order_id: "id")
client.orders.actions
client.orders.update_shipping(prodigi_order_id: "id", {})
client.orders.update_recipient(prodigi_order_id: "id", {})
client.orders.update_metadata(prodigi_order_id: "id", {})
client.orders.cancel(prodigi_order_id: "id", {})
```

### Quotes

```ruby
client.quotes.create({})
```

### Products 

```ruby
client.products.create({})
```

## Contributing

1. Fork it ( https://github.com/rdtclark/prodigi/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

When adding methods, add to the list of DEFINITIONS in lib/vultr.rb. Additionally, write a spec and add it to the list in the README.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT)
