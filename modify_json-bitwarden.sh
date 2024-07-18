#!/bin/bash

# Read the JSON file
json_file="$1"
json_content=$(cat "$json_file")

# Use jq to modify the JSON
modified_json=$(echo "$json_content" | jq '
  .items[] |= (
    if .login.uris and (.login.uris | length > 0) then
      .name += " " + (.login.uris[0].uri | sub("^http://"; ""))
    else
      .
    end
  )
')

# Write the modified JSON back to the file
echo "$modified_json" > "${json_file}.new"

echo "JSON file has been updated."
