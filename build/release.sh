#!/usr/bin/env bash

set -e -x

DRY_RUN=${DRY_RUN:-true}


validate() {
  if [ -z "${RELEASE_NAME}" ]; then
     echo "Env variable RELEASE_NAME, which sets version to be released is unset or set to the empty string"
     exit 1
  fi
}


replace() {
  sed -i'.backup' "s/latest/${RELEASE_NAME}/g" deploy/operator.yaml
}


commit() {
  git commit -a -m "${RELEASE_NAME} release"
}


tag() {
  git tag "${RELEASE_NAME}"
}


restore() {
  cp deploy/operator.yaml.backup deploy/operator.yaml
  git commit -a -m "Restored branch after release changes"
}


push() {
  git push --tags origin
  git push origin master
}


main() {
  validate
  replace

  if [[ "${DRY_RUN}" = true ]] ; then
    echo "DRY_RUN is set to true. Skipping..."
  else
    commit
    tag
    restore
    push
  fi
}


main
