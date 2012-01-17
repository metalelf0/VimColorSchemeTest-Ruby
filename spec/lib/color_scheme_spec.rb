require File.join(File.dirname(__FILE__), "..", "..", "lib", "color_scheme")

describe ColorScheme do

	let(:vim_connection) { stub("vim connection") }
	let(:color_scheme)   { ColorScheme.new(:name => "adaryn", :vim_connection => vim_connection ) }

	it "uses its vim connection to convert itself to html" do
		vim_connection.should_receive(:remote_cmd).with("colorscheme adaryn")
		vim_connection.should_receive(:remote_cmd).with("TOhtml")
		color_scheme.convert
	end

	it "uses its vim connection to write the output file to the target dir" do
		vim_connection.should_receive(:remote_cmd).with("w! a/b/adaryn.html")
		vim_connection.should_receive(:remote_cmd).with("bd!")
		color_scheme.write_to "a/b"
	end

end
