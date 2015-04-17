def random_bool
  Kernel.rand(2) == 1
end

def random_int(min,max)
  count = max - min + 1
  Kernel.rand(count) + min
end

def random_decimal(min,max,precision=2)
  multiplier = 10 ** precision
  count = max - min + 1
  puts "multiplier: #{multiplier}"
  (Kernel.rand(count * multiplier) + min * multiplier).to_f / multiplier
end

def random_value(values)
  values[random_int(0,(values.length-1))]
end
