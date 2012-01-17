class Language

  attr_reader :name
  attr_reader :template

  def initialize params
    @name = params[:name]
    @template = params[:template]
    setup_dir
  end

  def output_dir
    File.join("output", @name)
  end

  def index_file_path
    File.join("output", "#{@name}.html")
  end

  private

  def setup_dir
    Dir.mkdir(output_dir) unless Dir.exists?(output_dir)
  end

end
