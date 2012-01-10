#!/usr/bin/env ruby

class Dir
  def self.real_entries dir
    entries(dir).reject { |e| e == "." || e == ".." }
  end
end

def remote_cmd command
  system "mvim -f -n --noplugin -U vimrc --servername \"VIMCOLORS\" --remote-send \":#{command} <CR>\""
end

def colorscheme_td_for params
  string =  '<td width="33%" height="300px">'
  string += '<a class="frames" href="#">' + params[:color_name] + '</a><br>'
  string += '<iframe src="' + params[:color_path] + '" frameborder="0" width="100%" height="100%" scrolling="no"></iframe>'
  string += '</td>'
  string
end

def row_open
  return '<tr valign="top">'
end

def row_close
  return '</tr>'
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
  system "mvim -f -n --noplugin -U vimrc --servername \"VIMCOLORS\" #{language_filename_path} &"
  sleep 2
  vim_colorschemes.each_with_index do |vim_colorscheme, index|
    remote_cmd "colorscheme #{vim_colorscheme}"
    remote_cmd "TOhtml"
    remote_cmd "w! #{language_output_dir}/#{vim_colorscheme}.html"
    remote_cmd "bd!"
    puts "Language #{language_name}, colorscheme #{vim_colorscheme} done (#{index + 1}/#{vim_colorschemes.size})"
    language_index_file.puts(row_open()) if (index % 3 == 0)
    language_index_file.puts(colorscheme_td_for(:color_name => vim_colorscheme, :color_path => "#{language_name}/#{vim_colorscheme}.html"))
    language_index_file.puts(row_close()) if (index % 3 == 2)
    sleep 0.5
  end
  remote_cmd "qall!"
  File.open(File.join("template", "footer.html"), "r").readlines.each { |line| language_index_file.puts(line) }
end

