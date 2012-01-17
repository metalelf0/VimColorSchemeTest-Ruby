class FileWriter

	def initialize target_file
		@file = File.open(target_file, "w")
	end

	def write content
		@file.puts content
	end

end
