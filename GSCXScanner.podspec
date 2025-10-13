Pod::Spec.new do |s|
  s.name         = "GSCXScanner"
  s.version      = "4.0.2"
  s.summary      = "iOS Accessibility Scanner."
  s.description  = <<-DESC
  iOS Accessibility scanner framework to catch a11y issues during development.
                   DESC
  s.homepage     = "https://github.com/google/GSCXScanner"
  s.license      = "Apache License 2.0"
  s.author       = "j-sid"
  s.platform     = :ios, "10.0"
  s.source       = { :http => "https://github.com/Wallapop/GSCXScanner/releases/download/4.0.2-5-g5327240/GSCXScanner.framework.zip" }
  s.vendored_frameworks = "GSCXScanner.framework"
end
