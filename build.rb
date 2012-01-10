#!/usr/bin/env ruby

def remote_cmd command
  system "mvim -f -n --noplugin -U vimrc --servername \"VIMCOLORS\" --remote-send \":#{command} <CR>\""
end

def setup_languages
  hash = {}
  languages_filenames  = Dir.entries(File.join(File.dirname(__FILE__), 'samples')).reject { |e| e == "." || e == ".." } # TODO: extract reject
  languages_full_paths = languages_filenames.map { |filename| File.join("samples", filename) }
  language_names       = languages_filenames.map { |filename| filename.split(".").first }
  language_names.each_with_index do |name, index|
    hash[name] = languages_full_paths[index] 
  end
  hash
end

vim_colorschemes = Dir.entries(File.join(ENV['HOME'], '.vim', 'colors')).map { |c| c.gsub("\.vim", "") }.reject { |e| e == "." || e == ".." }

languages = setup_languages()

languages.each_pair do |language_name, language_filename_path|
  language_output_dir = File.join("output", language_name)
  Dir.mkdir(language_output_dir) unless Dir.exists?(language_output_dir)
  system "mvim -f -n --noplugin -U vimrc --servername \"VIMCOLORS\" #{language_filename_path} &"
  sleep 2
  vim_colorschemes.each_with_index do |vim_colorscheme, index|
    remote_cmd "colorscheme #{vim_colorscheme}"
    remote_cmd "TOhtml"
    remote_cmd "w! #{language_output_dir}/#{vim_colorscheme}.html"
    remote_cmd "bd!"
    puts "Language #{language_name}, colorscheme #{vim_colorscheme} done (#{index + 1}/#{vim_colorschemes.size})"
    sleep 0.5
  end
  remote_cmd "qall!"
end

