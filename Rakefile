require "bundler/gem_tasks"
task :default do
  system 'rm -rf public'
  system 'bundle exec cyborg server -w -C'
end

task :watch do
  system 'rm -rf public'
  system 'bundle exec cyborg watch -C'
end
