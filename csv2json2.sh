ruby -r json -r csv -e 'puts CSV.parse(STDIN, headers:true).map(&:to_h).to_json' < INPUT.csv 