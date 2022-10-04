# frozen_string_literal: true

class DRO
  attr_reader :attributes

  class << self
    def properties
      @properties ||= {}
    end

    def create_from_hash(hash)
      new(hash)
    end

    def create_from_json(json)
      hash = JSON.parse(json, symbolize_names: true)
      new(hash)
    end

    def create_from_object(obj)
      hash = {}
      @properties.each do |property, _|
        hash[property.to_sym] = obj.public_send(property)
      end
      new(hash)
    end

    private

    def property(name, type = :any, default: nil)
      name = name.to_s
      properties[name] = Property.new(name, type, default)
      define_method(name) { attributes[name.to_sym] }
    end
  end

  def initialize(attrs = {})
    self.attributes = attrs
  end

  def to_json(opts = {})
    @attributes.to_json(opts)
  end

  def to_hash
    @attributes.to_hash
  end

  private

  def attributes=(raw)
    @attributes = {}
    self.class.properties.each do |key, property|
      key = key.to_sym
      value = raw.fetch(key, property.default)
      @attributes[key] = property.cast(value)
    end
  end
end
