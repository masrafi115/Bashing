jq -s 'reduce .[] as $d ({}; . *= $d)' $1