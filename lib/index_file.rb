class IndexFile

  def initialize language
    @file = File.open(language.index_file_path, "w")
    @language = language.name
  end

  def append_colorscheme(colorscheme_name, index)
    @file.puts(row_open()) if (index % 3 == 0)
    @file.puts(colorscheme_td_for(colorscheme_name))
    @file.puts(row_close()) if (index % 3 == 2)
  end

  def write_header
    append_from_file(File.join("template", "header.html"))
  end

  def write_footer
    append_from_file(File.join("template", "footer.html"))
  end

  private

    def append_from_file file_path
      File.open(file_path, "r").readlines.each { |line| @file.puts(line) }
    end

    def colorscheme_td_for color_name
      string =  '<td width="33%" height="300px">'
      string += '<a class="frames" href="#">' + color_name + '</a><br>'
      string += '<iframe src="' + "#{@language}/#{color_name}.html" + '" frameborder="0" width="100%" height="100%" scrolling="no"></iframe>'
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
