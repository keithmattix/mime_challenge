# frozen_string_literal: true
$LOAD_PATH << 'spec' # add to load path
files = Dir.glob('spec/**/*.rb')
files.each { |file| require file.gsub(/^spec\/|.rb$/, '') }
