require 'aruba/cucumber'

Before do
  @aruba_timeout_seconds = 40
end

Then(/^the file "(.*?)" should exist$/) do |path|
  (File.exists?(path) and File.file?(path)).should be_true
end

Then(/^the directory "(.*?)" should exist$/) do |path|
  (File.exists?(path) and File.directory?(path)).should be_true
end
