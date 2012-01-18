require 'fileutils'

class FileCopier
	
	# FileCopier.new.copy(:from => "/a/b/*", :to => "/c/d")
	def copy args
		FileUtils.mkdir_p(args[:to]) unless File.directory?(args[:to])
		FileUtils.cp_r(Dir.glob(args[:from]), args[:to])
	end

end
