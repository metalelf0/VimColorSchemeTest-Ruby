#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'lib', 'color_scheme')
require File.join(File.dirname(__FILE__), 'lib', 'vim_connection')

class Dir
  def self.real_entries dir
    entries(dir).reject { |e| e == "." || e == ".." }
  end
end

def setup_languages
  hash = {}
  languages_filenames  = Dir.real_entries(File.join(File.dirname(__FILE__), 'samples'))
  languages_full_paths = languages_filenames.map { |filename| File.join("samples", filename) }
  language_names       = languages_filenames.map { |filename| filename.split(".").first }
  language_names.each_with_index do |name, index|
    hash[name] = languages_full_paths[index] 
  end
  hash
end

vim_colorschemes = Dir.real_entries(File.join(ENV['HOME'], '.vim', 'colors')).map { |c| c.gsub("\.vim", "") }

languages = setup_languages()

languages.each_pair do |language_name, language_filename_path|
  language_index_file = File.open(File.join("output", "#{language_name}.html"), "w")
  File.open(File.join("template", "header.html"), "r").readlines.each { |line| language_index_file.puts(line) }
  language_output_dir = File.join("output", language_name)
  Dir.mkdir(language_output_dir) unless Dir.exists?(language_output_dir)
  vim_connection = VimConnection.new(language_filename_path)
  sleep 2

  vim_colorschemes.each_with_index do |vim_colorscheme, index|
    scheme = ColorScheme.new(:name => vim_colorscheme, :vim_connection => vim_connection)
    scheme.convert
    scheme.write_to(language_output_dir)
    scheme.append_to_index(language_index_file, language_name, index)
    puts "Language #{language_name}, colorscheme #{vim_colorscheme} done (#{index + 1}/#{vim_colorschemes.size})"
    sleep 0.5
  end
  vim_connection.remote_cmd "qall!"
  File.open(File.join("template", "footer.html"), "r").readlines.each { |line| language_index_file.puts(line) }
end

