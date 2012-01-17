#require 'spec_helper'

require File.join(File.dirname(__FILE__), "..", "..", "lib", "language")

describe Language do

  before :each do
    Language.any_instance.stub(:setup_dir).and_return(true)
  end

  let(:language)       { Language.new(:name => "ruby", :template => "samples/ruby.rb") }

  it "builds its output dir" do
    language.output_dir.should == "output/ruby"
  end

  it "knows its index file path" do
    language.index_file_path.should == "output/ruby.html"
  end

end
