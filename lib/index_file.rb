require 'tilt'

class IndexFile

  def initialize language
    @language = language
  end

  def write(color_names)
    compiled_template = compile_template(color_names, @language.name)
    FileWriter.new(@language.index_file_path).write(compiled_template)
  end

  private

  def compile_template(color_names, language_name)
    template = Tilt.new('template/index.html.erb')
    template.render(self, :color_names => color_names, :language_name => language_name)
  end

end
