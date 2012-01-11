class Language

  attr_accessor :name
  attr_accessor :template
  attr_accessor :index_file
  attr_accessor :vim_connection

  def initialize params
    @name = params[:name]
    @template = params[:template]
    @index_file = IndexFile.new(self)
    @vim_connection = VimConnection.new(self)
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
