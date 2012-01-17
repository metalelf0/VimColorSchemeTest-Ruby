class Dir
  def self.real_entries dir
    entries(dir).reject { |e| e == "." || e == ".." }
  end
end

Dir.real_entries(File.join(File.dirname(__FILE__), '..', 'lib')).each do |library| #TODO: make this better. I mean, for real. This sucks
  require File.join(File.dirname(__FILE__), '..', 'lib', library)
end
