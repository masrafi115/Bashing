jq '.[] | .[0] | select( .summary != null ) | "pkg: " + .srcname + " summary: " + .summary  ' inrepo2.json | uniq > result2.json