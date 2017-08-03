#!/usr/bin/env bats

load test_helper

setup() {
  export GOVENV_ROOT="${TMP}/govenv"
  export GOVENV_VERSION="2.7.8"
  setup_version "2.7.8"
  create_executable "2.7.8" "virtualenv"
  stub govenv-prefix "echo '${GOVENV_ROOT}/versions/${GOVENV_VERSION}'"
  stub govenv-prefix "echo '${GOVENV_ROOT}/versions/${GOVENV_VERSION}'"
  stub govenv-prefix "echo '${GOVENV_ROOT}/versions/${GOVENV_VERSION}'"
  stub govenv-hooks "virtualenv : echo"
  stub govenv-rehash " : true"
  stub govenv-version-name "echo \${GOVENV_VERSION}"
  stub curl true
}

teardown() {
  unstub curl
  unstub govenv-version-name
  unstub govenv-prefix
  unstub govenv-hooks
  unstub govenv-rehash
  teardown_version "2.7.8"
  rm -fr "$TMP"/*
}

@test "resolve python executable from enabled version" {
  remove_executable "2.7.7" "python2.7"
  create_executable "2.7.8" "python2.7"
  remove_executable "2.7.9" "python2.7"

  stub govenv-exec "python -m venv --help : false"
  stub govenv-exec "virtualenv --verbose * : echo GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\""
  stub govenv-exec "python -s -m ensurepip : true"
  stub govenv-which "python2.7 : echo ${GOVENV_ROOT}/versions/2.7.8/bin/python2.7"

  run govenv-virtualenv --verbose --python=python2.7 venv

  assert_output <<OUT
GOVENV_VERSION=2.7.8 virtualenv --verbose --python=${GOVENV_ROOT}/versions/2.7.8/bin/python2.7 ${GOVENV_ROOT}/versions/2.7.8/envs/venv
OUT
  assert_success

  unstub govenv-which
  unstub govenv-exec

  remove_executable "2.7.7" "python2.7"
  remove_executable "2.7.8" "python2.7"
  remove_executable "2.7.9" "python2.7"
}

@test "resolve python executable from other versions" {
  remove_executable "2.7.7" "python2.7"
  remove_executable "2.7.8" "python2.7"
  create_executable "2.7.9" "python2.7"

  stub govenv-exec "python -m venv --help : false"
  stub govenv-exec "virtualenv --verbose * : echo GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\""
  stub govenv-exec "python -s -m ensurepip : true"
  stub govenv-which "python2.7 : false"
  stub govenv-whence "python2.7 : echo 2.7.7; echo 2.7.8; echo 2.7.9"
  stub govenv-which "python2.7 : echo ${GOVENV_ROOT}/versions/2.7.9/bin/python2.7"

  run govenv-virtualenv --verbose --python=python2.7 venv

  assert_output <<OUT
GOVENV_VERSION=2.7.8 virtualenv --verbose --python=${GOVENV_ROOT}/versions/2.7.9/bin/python2.7 ${GOVENV_ROOT}/versions/2.7.8/envs/venv
OUT
  assert_success

  unstub govenv-which
  unstub govenv-whence
  unstub govenv-exec

  remove_executable "2.7.7" "python2.7"
  remove_executable "2.7.8" "python2.7"
  remove_executable "2.7.9" "python2.7"
}

@test "cannot resolve python executable" {
  remove_executable "2.7.7" "python2.7"
  remove_executable "2.7.8" "python2.7"
  remove_executable "2.7.9" "python2.7"

  stub govenv-which "python2.7 : false"
  stub govenv-whence "python2.7 : false"
  stub govenv-which "python2.7 : false"

  run govenv-virtualenv --verbose --python=python2.7 venv

  assert_output <<OUT
govenv-virtualenv: \`python2.7' is not installed in govenv.
OUT
  assert_failure

  unstub govenv-which
  unstub govenv-whence

  remove_executable "2.7.7" "python2.7"
  remove_executable "2.7.8" "python2.7"
  remove_executable "2.7.9" "python2.7"
}
