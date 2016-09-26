require 'cobertura_xml_merger/version'
require 'nokogiri'

module CoberturaXmlMerger
  # Command Line Interface
  class Cli
    def self.start
      require 'optparse'

      options = {}
      OptionParser.new do |opts|
        opts.banner = 'Usage: cobertura_xml_merger [options] DIRECTORY'

        opts.on('-v', '--[no-]verbose', 'Run verbosely (default false)') do |v|
          options[:verbose] = v
        end

        opts.on('-o',
                '--output_file [FILE]',
                'File to write your merged xml (default cobertura_merged.xml)') do |o|
          options[:output] = o
        end
      end.parse!
      directory = ARGV.first

      Merger.new(directory, options).merge!
    end
  end

  class Merger
    def initialize(directory = '', verbose: false, output: 'cobertura_merged.xml')
      @dir = directory
      @verbose = verbose
      @output = output
    end

    def merge!
      # @logger.info "Merging xml reports in #{@dir}"
      puts "Merging xml reports in #{@dir}" if @verbose
      save(merge_files(files))
    end

    def files
      return [] unless Dir.exist?(@dir)
      Dir["#{@dir}/*.xml"]
    end

    # Merges all the files supplied
    def merge_files(files)
      files.reduce(nil) do |merged, file|
        puts "Merging #{file}" if @verbose
        merge(merged, file)
      end
    end

    # Takes two files with xml reports and merges them into a string
    def merge(xml1, file2)
      xml2 = File.read(file2)
      return xml2 unless xml1

      merge_xml(xml1, xml2)
    end

    # Takes two xml reports as strings and merges them into a new string
    def merge_xml(string1, string2)
      xml1 = Nokogiri::XML(string1)
      xml2 = Nokogiri::XML(string2)

      # Only supports one package
      package1 = xml1.xpath('//package').first
      package2 = xml2.xpath('//package').first
      merged_package = merge_packages(package1, package2)

      xml1.css('coverage packages').first.content = ''
      merged_package.parent = xml1.css('coverage packages').first
      xml1.to_s
    end

    # This method modifies package2 to include package 1 line hits
    def merge_packages(package1, package2)
      klasses = {}
      package1.css('class').each do |klass|
        lines = {}
        klass.css('line').each do |line|
          lines[line['number']] = line['hits'].to_i
        end
        klasses[klass['filename']] = lines
      end

      package2.css('class').each do |klass|
        klass.css('line').each do |line|
          lines = klasses[klass['filename']]
          begin
            line['hits'] = lines[line['number']] + line['hits'].to_i
          rescue => e
            puts "error matching #{klass['filename']} line #{line['number']}" if @verbose
            puts lines.inspect if @verbose
            throw e
          end
        end
      end

      package2
    end

    def save(xml)
      File.open(@output, 'w') do |output_file|
        output_file.puts(xml)
      end
    end
  end
end
