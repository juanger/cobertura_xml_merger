# CoberturaXmlMerger

Merge Cobertura XML reports into a single file.

## Limitations

  1) It assumes you used the simplecov-cobertura gem to generate the reports which means only one package
    per report.

  2) It assumes your code is the same, so all reports should have the same number of classes and lines
    in each class

## Installation

    $ gem install cobertura_xml_merger

## Usage

    cobertura_xml_merger -o merged_output.xml directory

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/juanger/cobertura_xml_merger.
