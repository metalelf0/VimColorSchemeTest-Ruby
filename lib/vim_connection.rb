class VimConnection

  def initialize language_template
    system "mvim -f -n --noplugin -U vimrc --servername \"VIMCOLORS\" #{language_template} &"
  end

  def remote_cmd command
    system "mvim -f -n --noplugin -U vimrc --servername \"VIMCOLORS\" --remote-send \":#{command} <CR>\""
  end
end
