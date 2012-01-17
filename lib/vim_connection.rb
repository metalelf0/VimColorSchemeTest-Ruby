class VimConnection

  VIM_COMMAND = "mvim -f -n --noplugin -U vimrc --servername VIMCOLORS"

  def initialize language
    @language = language
  end

  def remote_cmd command
    command = ":#{command} <CR>"
    Kernel.system "#{VIM_COMMAND} --remote-send #{command.inspect}"
  end

  def open
    Kernel.spawn "#{VIM_COMMAND} #{@language.template}"
  end

  def close
    remote_cmd "qall!"
  end

end
