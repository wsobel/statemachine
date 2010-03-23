$:.unshift('lib')
require 'rubygems'
require 'rake/gempackagetask'
require 'rake/clean'
require 'rake/rdoctask'
require 'spec/rake/spectask'
require 'statemachine'

PKG_NAME = "statemachine"
PKG_VERSION   = Statemachine::VERSION::STRING
PKG_TAG = Statemachine::VERSION::TAG
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"
PKG_FILES = FileList[
  '[A-Z]*',
  'lib/**/*.rb', 
  'spec/**/*.rb' 
]

task :default => :spec

desc "Run all specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

WEB_ROOT = File.expand_path('~/Projects/slagyr.github.com/statemachine/')

desc 'Generate RDoc'
rd = Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = "#{WEB_ROOT}/rdoc"
  rdoc.options << '--title' << 'Statemachine' << '--line-numbers' << '--inline-source' << '--main' << 'README.rdoc'
  rdoc.rdoc_files.include('README.rdoc', 'CHANGES', 'lib/**/*.rb')
end
task :rdoc

spec = Gem::Specification.new do |s|
  s.name = PKG_NAME
  s.version = PKG_VERSION
  s.summary = Statemachine::VERSION::DESCRIPTION
  s.description = "Statemachine is a ruby library for building Finite State Machines (FSM), also known as Finite State Automata (FSA)."
  s.files = PKG_FILES.to_a
  s.require_path = 'lib'
  s.test_files = Dir.glob('spec/*_spec.rb')
  s.require_path = 'lib'
  s.autorequire = 'statemachine'
  s.author = "Micah Martin"
  s.email = "statemachine-devel@rubyforge.org"
  s.homepage = "http://statemachine.rubyforge.org"
  s.rubyforge_project = "statemachine"
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

def egrep(pattern)
  Dir['**/*.rb'].each do |fn|
    count = 0
    open(fn) do |f|
      while line = f.gets
        count += 1
        if line =~ pattern
          puts "#{fn}:#{count}:#{line}"
        end
      end
    end
  end
end

desc "Look for TODO and FIXME tags in the code"
task :todo do
  egrep /(FIXME|TODO|TBD)/
end

task :release => [:clobber, :verify_committed, :verify_user, :verify_password, :spec, :publish_packages, :tag, :publish_website, :publish_news]

desc "Verifies that there is no uncommitted code"
task :verify_committed do
  IO.popen('svn stat') do |io|
    io.each_line do |line|
      raise "\n!!! Do a svn commit first !!!\n\n" if line =~ /^\s*M\s*/
    end
  end
end

desc "Creates a tag in svn"
task :tag do
  puts "Creating tag in SVN"
  `svn cp svn+ssh://#{ENV['RUBYFORGE_USER']}@rubyforge.org/var/svn/statemachine/trunk svn+ssh://#{ENV['RUBYFORGE_USER']}@rubyforge.org/var/svn/statemachine/tags/#{PKG_VERSION} -m "Tag release #{PKG_TAG}"`
  puts "Done!"
end

desc 'Generate HTML documentation for website'
task :webgen do
  system "rm -rf doc/website/out"
  system "rm -rf doc/website/webgen.cache"
  system "cd doc/website; webgen -v render; cp -rf out/* #{WEB_ROOT}"
end

desc "Build the website, but do not publish it"
task :website => [:webgen, :rdoc]

task :verify_user do
  raise "RUBYFORGE_USER environment variable not set!" unless ENV['RUBYFORGE_USER']
end

task :verify_password do
  raise "RUBYFORGE_PASSWORD environment variable not set!" unless ENV['RUBYFORGE_PASSWORD']
end