class ColorScheme

  def initialize params
    @name = params[:name]
    @vim_connection = params[:vim_connection]
  end

  def convert
    @vim_connection.remote_cmd "colorscheme #{@name}"
    @vim_connection.remote_cmd "TOhtml"
  end

  def write_to output_dir
    @vim_connection.remote_cmd "w! #{output_dir}/#{@name}.html"
    @vim_connection.remote_cmd "bd!"
  end

end
