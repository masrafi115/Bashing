jq 'to_entries[]| {caption: (.value.caption), page: (.value.page)|tostring}' $1