require "bundler/gem_tasks"
task :default do
  system 'rm -rf public'
  system 'bundle exec cyborg server -w -C'
end

task :watch do
  system 'rm -rf public'
  system 'bundle exec cyborg watch -C'
end

task :upload do
  require 's3'

  bucket = S3::Service.new(access_key_id: ENV['AWS_KEY'], secret_access_key: ENV['AWS_SECRET']).buckets.find('megatron-assets')

  Dir.glob('public/*') do |file|
    upload bucket, file
  end

  upload bucket, "app/assets/images/megatron/favicon.ico"
  upload bucket, "app/assets/images/megatron/logo.svg"

end

def upload(bucket, file)

  name = file.split('/').last
  obj = bucket.objects.build("assets/megatron/#{name}")

  obj.acl = :public_read

  obj.content_type = if name.end_with?('.js') || name.end_with?('.js.gz')
    'application/javascript'
  elsif name.end_with?('.css') || name.end_with?('.css.gz')
    'text/css'
  elsif name.end_with?('.json') || name.end_with?('.map')
    'application/json'
  elsif name.end_with?('.ico')
    'image/x-icon'
  elsif name.end_with?('.svg')
    'image/svg+xml'
  else
    'text/plain'
  end
  
  obj.content_encoding = 'gzip' if name.end_with?('.gz')
  obj.content = open(file)
  
  puts "Uploading #{file} to megatron-assets on S3..."

  if obj.save
    puts "Success!"
  else
    puts "Failure :("
    exit 1
  end
end
