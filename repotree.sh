#!/bin/bash
#https://github.com/xamarin/urho-samples
# a little bit bug is, we cannot determine branch so , some repo might be 'main' branch 
echo "Enter repository URL: "
read repo_url
echo "Enter branch: "
read branch
repos_url=$(echo $repo_url | sed 's/github\.com/api.github.com\/repos/')
#echo $repos_url
data=$(curl -H "Accept: application/vnd.github.v3+json" "$repos_url/git/trees/$branch?recursive=1")
size=$(curl -s $repos_url | jq '.size' | numfmt --to=iec --from-unit=1024)
echo $data |  jq '.tree[].path' | tree --fromfile
echo "Size "$size
#curl -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/xamarin/urho-samples/git/trees/master?recursive=1" | jq '.tree[].path' | tree --fromfile
