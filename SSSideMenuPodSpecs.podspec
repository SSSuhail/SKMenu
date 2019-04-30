Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '10.0'
s.name = "SideMenu"
s.summary = "SideMenu is simple way to have menu's in app, both right and left menu can be added."
s.requires_arc = true

# 2
s.version = "1.1"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4
s.author = { "Suhail Shabir" => "suhailshabir176@gmail.com" }

# 5
s.homepage = "https://github.com/SSSuhail/SSSideMenu"

# 6
s.source = { :git => "https://github.com/SSSuhail/SSSideMenu.git",
:tag => "#{s.version}" }


# 7
s.framework = "UIKit"

# 8
s.source_files = "SideMenu/**/*.{swift}"

# 9
s.resources = "SideMenu/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# 10
s.swift_version = "5.0"

end


