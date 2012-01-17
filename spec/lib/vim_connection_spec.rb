require File.join(File.dirname(__FILE__), "..", "..", "lib", "vim_connection")

describe VimConnection do

	let(:language)       { stub("Language", :template => "samples/ruby.html") }
	let(:vim_connection) { VimConnection.new(language) } 

	it "spawns a new vim connection on open" do
		Kernel.should_receive(:spawn).with(/mvim.*samples\/ruby\.html/).and_return(true)
		vim_connection.open
	end

	it "issues a command to close all buffers and quit on close" do
		vim_connection.should_receive(:remote_cmd).with("qall!")
		vim_connection.close
	end


end
