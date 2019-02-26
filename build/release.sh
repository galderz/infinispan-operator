#!/usr/bin/env bash

set -e -x

DRY_RUN=${DRY_RUN:-true}


validateReleaseName() {
  if [ -z "${RELEASE_NAME}" ]; then
     echo "Env variable RELEASE_NAME, which sets version to be released is unset or set to the empty string"
     exit 1
  fi
}


replaceReleaseName() {
  sed -i'.backup' "s/latest/${RELEASE_NAME}/g" deploy/operator.yaml
}


commitRelease() {
  git commit -a -m "${RELEASE_NAME} release"
}


restoreBranch() {
  cp deploy/operator.yaml.backup deploy/operator.yaml
  git commit -a -m "Restored branch after release changes"
}


main() {
  validateReleaseName
  replaceReleaseName

  if [[ "${DRY_RUN}" = true ]] ; then
    echo "DRY_RUN is set to true. Skipping..."
  else
    commitRelease
    restoreBranch
  fi
}


main
