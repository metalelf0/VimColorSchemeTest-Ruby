#!/usr/bin/env ruby

require 'erb'
require 'tilt'

class Dir
  def self.real_entries dir
    entries(dir).reject { |e| e == "." || e == ".." }
  end
end

Dir.real_entries(File.join(File.dirname(__FILE__), 'lib')).each do |library|
  require File.join(File.dirname(__FILE__), 'lib', library)
end


def setup_languages
  languages = []
  languages_filenames  = Dir.real_entries(File.join(File.dirname(__FILE__), 'samples'))
  languages_full_paths = languages_filenames.map { |filename| File.join("samples", filename) }
  language_names       = languages_filenames.map { |filename| filename.split(".").first }
  language_names.each_with_index do |name, index|
    languages << Language.new(:name => name, :template => languages_full_paths[index])
  end
  languages
end

vim_colorschemes = Dir.real_entries(File.join(ENV['HOME'], '.vim', 'colors')).map { |c| c.gsub("\.vim", "") }[0..6]

languages = setup_languages()

languages.each do |language|
  language.vim_connection.open
  sleep 2
  color_names = []

  vim_colorschemes.each_with_index do |vim_colorscheme, index|
    scheme = ColorScheme.new(:name => vim_colorscheme, :vim_connection => language.vim_connection)
    scheme.convert
    scheme.write_to(language.output_dir)
    color_names << scheme.name
    puts "Language #{language.name}, colorscheme #{scheme.name} done (#{index + 1}/#{vim_colorschemes.size})"
    sleep 0.5
  end
  language.vim_connection.close
  language.index_file.write(color_names)

end

