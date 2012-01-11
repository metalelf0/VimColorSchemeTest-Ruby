class ColorScheme

  def initialize params
    @name = params[:name]
  end

  def convert
    remote_cmd "colorscheme #{@name}"
    remote_cmd "TOhtml"
  end

  def write_to output_dir
    remote_cmd "w! #{output_dir}/#{@name}.html"
    remote_cmd "bd!"
  end

  def append_to_index(file, language_name, index)
    file.puts(row_open()) if (index % 3 == 0)
    file.puts(colorscheme_td_for(:color_name => @name, :color_path => "#{language_name}/#{@name}.html"))
    file.puts(row_close()) if (index % 3 == 2)
  end

  private

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

end
