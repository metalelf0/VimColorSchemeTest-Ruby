require File.join(File.dirname(__FILE__), "..", "..", "lib", "file_copier")

describe FileCopier do

	let(:file_copier) { FileCopier.new }

	it "copies files from a directory to another" do
		FileUtils.rm_rf(["/tmp/a", "/tmp/b"])
		Dir.mkdir("/tmp/a") unless File.directory?("/tmp/a")
		FileUtils.touch(["/tmp/a/1", "/tmp/a/2"])


		file_copier.copy(:from => "/tmp/a/*", :to => "/tmp/b")
		Dir.entries("/tmp/b").should have(4).files
	end

end
