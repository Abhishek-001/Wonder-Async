
Pod::Spec.new do |s|

	s.name         = "Wonder-Async"
	s.version      = "1.0.0"
	s.summary      = "Swift iOS Networking Library"
	s.description  = "An iOS HTTP Library written in Swift to download multiple images & other 				data."
	s.homepage     = "https://github.com/Abhishek-001/Wonder-async"
 
	s.license      = { :type => 'MIT', :file => 'License' }

  	s.author       = { "Abhishek Rathi" => "work.abhirathi@gmail.com" }
 	s.platform     = :ios, "11.0"

  	s.source       = { :git => "https://github.com/Abhishek-001/Wonder-Async.git", :tag =>s.version.to_s }

	s.source_files = "Wonder-Async"

end


