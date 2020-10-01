class Property
  attr_accessor :name, :type, :default

  def initialize(name, type, default)
    @name = name.to_s
    @type = type
    @default = default
  end

  FALSE_VALUES = [false, 0, '0', 'f', 'F', 'false', 'FALSE', 'off', 'OFF'].freeze

  TYPECASTS = {
    integer: ->(value) { value.to_i },
    float: ->(value) { value.to_f },
    string: ->(value) { value.to_s },
    bool: ->(value) { !FALSE_VALUES.include?(value) },
    symbol: ->(value) { value.to_sym },
    array: ->(value) { Array(value) },
    hash: ->(value) { Hash(value) },
    time: ->(value) { Time.parse(value) },
    any: ->(value) { value }
  }.freeze

  def cast(value)
    if type.respond_to?(:new)
      cast_by_new(value)
    else
      cast_by_lambda_def(value)
    end
  end

  private

  def cast_by_new(value)
    return type.new(*value) if value.is_a?(Array)

    type.new(value)
  end

  def cast_by_lambda_def(value)
    typecast = TYPECASTS.fetch(type, type)
    typecast.call(value)
  end
end
