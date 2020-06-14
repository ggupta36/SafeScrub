#!/bin/bash

# Calls the base script, and also
# 1. Directs the output through a filter so that items in  "no-delete.txt" are not in the ultimate output script
# 2. Reverts the logged-in user to what it was before the script is run.
function revert_authentication() {
  gcloud config set account ${original_account}
  gcloud config set project ${original_project}
}

trap "cleanup" INT

original_account=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")
original_project=$(gcloud config get-value project)

./base-generate-script.sh "$@" |
  grep -v -f no-delete.txt

revert_authentication
