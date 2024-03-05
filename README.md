## Policy OCR Development Test

### Setup
All dependencies are handled via Docker. If you don't want to install Docker, you can run the code with Ruby 3.1.
To get started build the docker image. This will install the gems, and copy the code to the docker image.

```shell
docker build -t kin:dev-test .
```

### Setup
Once the docker image is built, launch the image to a shell.

```shell
docker run --rm -it kin:dev-test sh
```

### Run

You can run the ruby code, or rspec as usual from within this shell. This example uses `pry`, but you can use `irb` if needed.

```ruby
$ pry -r './lib/policy_ocr.rb'
[1] pry(main)> ocr = ocr = PolicyOcr.new('spec/fixtures/sample.txt')
[2] pry(main)> ocr.save('output.txt') # Write the output to a file specified
[3] pry(main)> ocr.output # view the output hash with permutations applied
[4] pry(main)> ocr.output(with_permutations: false) # without permutations
```

rspec tests will output to the terminal as normal, and generate a coverage report.

```shell
$ bundle exec rspec # run specs
..........

Finished in 0.04445 seconds (files took 0.12301 seconds to load)
10 examples, 0 failures

Coverage report generated for RSpec to /workspace/coverage. 46 / 46 LOC (100.0%) covered.
```
