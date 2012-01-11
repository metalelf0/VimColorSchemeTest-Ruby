class VimConnection

  def initialize language
    @language = language
  end

  def remote_cmd command
    system "mvim -f -n --noplugin -U vimrc --servername \"VIMCOLORS\" --remote-send \":#{command} <CR>\""
  end

  def open
    system "mvim -f -n --noplugin -U vimrc --servername \"VIMCOLORS\" #{@language.template} &"
  end

  def close
    remote_cmd "qall!"
  end

end
