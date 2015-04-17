def by(message)
  if block_given?
    yield
  else
    pending message
  end
end

alias and_by by

def and_it(message)
  if block_given?
    $stdout.puts "#{message},"
    yield
  else
    pending message
  end
end
