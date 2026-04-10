#!/bin/bash
# Delete ALL Nextcloud bookmarks
# https://sleeplessbeastie.eu/

# usage info
usage(){
  echo "Usage:"
  echo "  $0 -r nextcloud_url -u username -p passsword"
  echo ""
  echo "Parameters:"
  echo "  -r nextcloud_url   : set Nextcloud URL (required)"
  echo "  -u username        : set username (required)"
  echo "  -p password        : set password (required)"
  echo ""
}

# parse parameters
while getopts "r:u:p:f:t" option; do
  case $option in
    "r")
      param_nextcloud_address="${OPTARG}"
      param_nextcloud_address_defined=true
      ;;
    "u")
      param_username="${OPTARG}"
      param_username_defined=true
      ;;
    "p")
      param_password="${OPTARG}"
      param_password_defined=true
      ;;
    \?|:|*)
      usage
      exit
      ;;
  esac
done

if [ "${param_nextcloud_address_defined}" = true ] && \
   [ "${param_username_defined}"          = true ] && \
   [ "${param_password_defined}"          = true ]; then

  continue_pagination="1"
  while [ "${continue_pagination}" -eq "1" ]; do
    bookmarks=$(curl --silent --output - -X GET --user "${param_username}:${param_password}" --header "Accept: application/json" "${param_nextcloud_address}/index.php/apps/bookmarks/public/rest/v2/bookmark" | \
                jq -r '.data[].id')
    if [ -z "${bookmarks}" ]; then
      echo "Nextcloud bookmarks list is empty. Stopping."
      continue_pagination="0"
    else
      for bookmark in ${bookmarks}; do
        status=$(curl --silent -X DELETE --user "${param_username}:${param_password}"  "${param_nextcloud_address}/index.php/apps/bookmarks/public/rest/v2/bookmark/${bookmark}" | 
                 jq -r 'select(.status != "success") | .status')
        if [ -n "${status}" ]; then
          echo "There was an error when deleting Nextcloud bookmark id \"${bookmark}\". Stopping."
          exit 1
        else
          echo "Deleted Nextcloud bookmark id \"${bookmark}\""
        fi
      done
    fi
  done
else
  usage
fi
Usage
