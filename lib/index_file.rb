class IndexFile

  def initialize language
    @language = language
  end

  def write(color_names)
    template = Tilt.new('template/index.html.erb')
    File.open(@language.index_file_path, "w") do |file|
      file.puts template.render(self, :color_names => color_names, :language_name => @language.name)
    end
  end

end
