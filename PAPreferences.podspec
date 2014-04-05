Pod::Spec.new do |s|
  s.name         = "PAPreferences"
  s.version      = "0.1"
  s.summary      = "A short description of PAPreferences."

  s.description  = <<-DESC
                   A longer description of PAPreferences in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/dhennessy/PAPreferences"
  s.author       = { "Denis Hennessy" => "denis@hennessynet.com" }
  s.license      = { :type => 'BSD', :file => 'LICENSE' }

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.source       = { :git => 'https://github.com/dhennessy/PAPreferences.git', :tag => s.version.to_s } 
  s.source_files = 'PAPreferences'
  s.requires_arc = true
end
