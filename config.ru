require 'rack'

app = Proc.new do |env|
  ['200', { 'Content-Type' => 'text/plain' }, ['Hi']]
end

run app
