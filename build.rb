#!/usr/bin/env ruby

require 'erb'

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

colorschemes_output_dir = File.join(File.dirname(__FILE__), 'output', 'colorschemes')

FileCopier.new.copy(
  :from => File.join(ENV['HOME'], '.vim', 'colors', '*'),
  :to   => colorschemes_output_dir
)

FileCopier.new.copy(
  :from => File.join(File.dirname(__FILE__), 'utils', '*'),
  :to   => File.join(File.dirname(__FILE__), 'output')
)


vim_colorschemes = Dir.real_entries(colorschemes_output_dir).map { |c| c.gsub("\.vim", "") }

languages = setup_languages()

languages.each do |language|
  vim_connection = VimConnection.new(language)
  vim_connection.open
  sleep 2
  color_names = []

  vim_colorschemes.each_with_index do |vim_colorscheme, index|
    scheme = ColorScheme.new(:name => vim_colorscheme, :vim_connection => vim_connection)
    scheme.convert
    scheme.write_to(language.output_dir)
    color_names << scheme.name
    puts "Language #{language.name}, colorscheme #{scheme.name} done (#{index + 1}/#{vim_colorschemes.size})"
    sleep 0.5
  end
  vim_connection.close
  index_file = IndexFile.new(language)
  index_file.write(color_names)

end

