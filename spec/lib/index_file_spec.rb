require File.join(File.dirname(__FILE__), "..", "..", "lib", "index_file")
require File.join(File.dirname(__FILE__), "..", "..", "lib", "file_writer")
require 'tilt'

describe IndexFile do

	let(:language)   { stub("ruby", :index_file_path => "a/b/index.html", :name => "Ruby") }
	let(:index_file) { IndexFile.new(language) }

	it "render its template" do
		index_file.should_receive(:compile_template).with( [ "adaryn", "github" ], "Ruby").and_return("<html>Hallo</html>")
		file_writer = stub("file writer")
		FileWriter.should_receive(:new).with("a/b/index.html").and_return file_writer
		file_writer.should_receive(:write).with("<html>Hallo</html>")
		index_file.write( [ "adaryn", "github" ] )
	end

end
