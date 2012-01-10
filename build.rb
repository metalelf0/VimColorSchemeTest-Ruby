def remote_cmd command
  system "mvim -f -n --noplugin -u vimrc --servername \"VIMCOLORS\" --remote-send \":#{command} <CR>\""
end

vim_colorschemes = Dir.entries(File.join(ENV['HOME'], '.vim', 'colors')).map { |c| c.gsub("\.vim", "") }.reject { |e| e == "." || e == ".." }
#system "mvim -f -n --noplugin -u vimrc --servername \"VIMCOLORS\" samples/ruby.rb"
vim_colorschemes.each do |vim_colorscheme|
  remote_cmd "colorscheme #{vim_colorscheme}"
  remote_cmd "TOhtml"
  remote_cmd "w! output/#{vim_colorscheme}.html"
  remote_cmd "bd!"
  #command = "mvim -f -n --noplugin -u vimrc samples/ruby.rb -c \"colorscheme #{vim_colorscheme}\" -c \"TOhtml\" -c \"w\! output/#{vim_colorscheme}.html\" "
end

