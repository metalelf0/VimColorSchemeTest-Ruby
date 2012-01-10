#!/usr/bin/env ruby

def remote_cmd command
  system "mvim -f -n --noplugin -U vimrc --servername \"VIMCOLORS\" --remote-send \":#{command} <CR>\""
end

vim_colorschemes = Dir.entries(File.join(ENV['HOME'], '.vim', 'colors')).map { |c| c.gsub("\.vim", "") }.reject { |e| e == "." || e == ".." }
system "mvim -f -n --noplugin -U vimrc --servername \"VIMCOLORS\" samples/ruby.rb &"
sleep 2
vim_colorschemes.each_with_index do |vim_colorscheme, index|
  remote_cmd "colorscheme #{vim_colorscheme}"
  remote_cmd "TOhtml"
  remote_cmd "w! output/#{vim_colorscheme}.html"
  remote_cmd "bd!"
  puts "Colorscheme #{vim_colorscheme} done (#{index}/#{vim_colorschemes.size})"
  sleep 0.5
end
remote_cmd "qall!"

