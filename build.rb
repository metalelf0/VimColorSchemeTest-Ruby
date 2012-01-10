vim_colorschemes = Dir.entries(File.join(ENV['HOME'], '.vim', 'colors')).map { |c| c.gsub("\.vim", "") }
vim_colorschemes.each do |vim_colorscheme|
  command = "mvim -f -n --noplugin -u vimrc samples/ruby.rb -c \"colorscheme #{vim_colorscheme}\" -c \"TOhtml\" -c \"w\! output/#{vim_colorscheme}.html\" -c \"qa\!\""
  system(command)
end
