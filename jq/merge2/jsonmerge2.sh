jq -n 'reduce inputs as $item ({}; . *= $item)' $1 $2
