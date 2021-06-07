# -*- encoding: utf-8 -*-
Gem::Specification.new do |spec|
  spec.name = 'registration-client'
  spec.version = '0.0.0'
  spec.summary = 'Registration Client'
  spec.description = ' '

  spec.authors = ['Joseph Choe']
  spec.email = ['joseph@josephchoe.com']
  spec.homepage = 'https://github.com/bluepuppetcompany/registration-component'

  spec.require_paths = ['lib']
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.6'

  files = Dir['lib/registration/**/*.rb']

  files += Dir['lib/registration_component/{controls.rb,controls/**/*.rb}']

  files << 'lib/registration_component/load.rb'

  File.read('lib/registration_component/load.rb').each_line.map do |line|
    next if line == "\n"

    _, filename = line.split(/[[:blank:]]+/, 2)

    filename.gsub!(/['"]/, '')
    filename.strip!

    filename = File.join('lib', "#{filename}.rb")

    files << filename if File.exist?(filename)
  end

  spec.files = files

  spec.add_runtime_dependency 'evt-messaging-postgres'

  spec.add_development_dependency 'test_bench'
end
