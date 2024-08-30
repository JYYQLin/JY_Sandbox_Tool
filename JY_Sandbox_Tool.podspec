Pod::Spec.new do |spec|
  	spec.name         = "JY_Sandbox_Tool"
  	spec.version      = "1.0.0"
  	spec.summary      = "自用沙盒缓存计算工具"
  	spec.homepage     = "https://github.com/JYYQLin/JY_Sandbox_Tool"
  	spec.license      = { :type => "MIT", :file => "LICENSE" }
  	spec.author       = { "JYYQLin" => "No mailBox" }
  	spec.platform     = :ios, "13.0"
  	spec.source       = { :git => "https://github.com/JYYQLin/JY_Sandbox_Tool.git", :tag => "#{spec.version}" }
  	spec.source_files  = "JY_Sandbox_Tool/*.{h,m,swift}"
	spec.swift_versions = ['5.0', '5.1', '5.2']
end
