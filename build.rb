#!/usr/bin/env ruby

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

vim_colorschemes = Dir.real_entries(File.join(ENV['HOME'], '.vim', 'colors')).map { |c| c.gsub("\.vim", "") }

languages = setup_languages()

languages.each do |language|
  language.index_file.write_header
  language.vim_connection.open
  sleep 2

  vim_colorschemes.each_with_index do |vim_colorscheme, index|
    scheme = ColorScheme.new(:name => vim_colorscheme, :language => language)
    scheme.convert
    scheme.write_to(language.output_dir)
    language.index_file.append_colorscheme(scheme.name, index)
    puts "Language #{language.name}, colorscheme #{scheme.name} done (#{index + 1}/#{vim_colorschemes.size})"
    sleep 0.5
  end
  language.vim_connection.close
  language.index_file.write_footer
end

