puts ENV['GEM_PATH']
def foo
  puts ">"
  bar = false unless ENV['BARRR']='true'
  puts ">>>"
  puts bar.inspect
end

foo