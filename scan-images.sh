#!/bin/bash

echo "${{ github.event.issue.body }}" | tr -d "[]" | tr -s "," "\n" | tac > newscan.txt
          input=newscan.txt

while IFS= read -r image
do
    trivy image --security-checks vuln --quiet --format template --exit-code 1 "$image"
    status=$(echo $?)
    if [ "$status" -eq 0 ]; then safety="SAFE"; else safety="UNSAFE"; fi
    echo "\"image\": \"$image\""
    echo "\"status\": \"$safety\""
done < "$input"