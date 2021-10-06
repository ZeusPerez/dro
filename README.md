# dro

DRO stands for data Ruby object, a term invented, that it is useful for wrapping, serializing and deserializing information in order to be easy to move through the code or network communications.

## How to use it?
First, you need to define the information that you want to move in a class inheriting from the DRO class. In the definition, you have to specify one of the types defined in `TYPECAST` in [`property.rb`](lib/property.rb):


```ruby
class P < DRO
	property :registered, :bool, default: false
  property :name, :string
  property :number, :integer
end
```


We can create a new player from a hash, a JSON, a struct, or anotoher object, that doesn't have to be the same class, using one of the builder methods:
- `create_from_hash(hash)`
- `create_from_json(json)`
- `create_from_object(obj)`

```ruby
 irb > playerHash = {name: "Lebron", number: 23}
 => {:name=>"Lebron", :number=>23}
 irb > player = Player.create_from_hash(playerHash)
 => #<P:0x00007fd88cafaf70 @attributes={"registered"=>false, "name"=>"Lebron", "number"=>23}>
 ```

The serializing and deserializing behaviour are not different from using `to_hash` or `to_json` but the value that this tool provides remain in the way of defining the types, the defaults and fencing the information that you want to move in the sender and receiver code.
