require 'yaml'
require File.dirname(__FILE__) + '/../lib/wufoo'
config = YAML::load(File.read(ENV['HOME'] + '/.wufoo'))

client = Wufoo::Client.new('http://orderedlist.wufoo.com', config['api_key'])
submission = Wufoo::Submission.new(client, 'orderedlistcom-project-request')

response = submission.add_params({
  '1'  => 'John Nunemaker',
  '12' => 'nunemaker@gmail.com',
  '4'  => '1231231234',
  '5'  => 'http://addictedtonew.com',
  '6'  => 'ASAP!',
  '10' => '1,000,000',
  '11' => 'My cool project!',
}).process

if response.success?
  puts response.message
else
  # Something was wrong with the request
  # (missing api key, invalid form, etc)
  if response.fail?
    puts response.error    
  end
  
  # validation errors
  unless response.valid?
    errors = response.errors.collect { |e| "#{e.field_id} (#{e.code}): #{e.message}" }    
    puts errors * "\n"
  end
end