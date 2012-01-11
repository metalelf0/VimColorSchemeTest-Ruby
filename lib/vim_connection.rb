class VimConnection

  def initialize language_filename_path
    system "mvim -f -n --noplugin -U vimrc --servername \"VIMCOLORS\" #{language_filename_path} &"
  end

  def remote_cmd command
    system "mvim -f -n --noplugin -U vimrc --servername \"VIMCOLORS\" --remote-send \":#{command} <CR>\""
  end
end
