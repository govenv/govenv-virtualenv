#!/usr/bin/env bats

load test_helper

setup() {
  export GOVENV_ROOT="${TMP}/govenv"
  mkdir -p "${GOVENV_ROOT}/versions/2.7.6"
  mkdir -p "${GOVENV_ROOT}/versions/3.3.3"
  mkdir -p "${GOVENV_ROOT}/versions/venv27"
  mkdir -p "${GOVENV_ROOT}/versions/venv33"
}

@test "list virtual environments only" {
  stub govenv-version-name ": echo system"
  stub govenv-virtualenv-prefix "2.7.6 : false"
  stub govenv-virtualenv-prefix "3.3.3 : false"
  stub govenv-virtualenv-prefix "venv27 : echo \"${GOVENV_ROOT}/versions/2.7.6\""
  stub govenv-virtualenv-prefix "venv33 : echo \"${GOVENV_ROOT}/versions/3.3.3\""

  run govenv-virtualenvs

  assert_success
  assert_output <<OUT
  venv27 (created from ${GOVENV_ROOT}/versions/2.7.6)
  venv33 (created from ${GOVENV_ROOT}/versions/3.3.3)
OUT

  unstub govenv-version-name
  unstub govenv-virtualenv-prefix
}

@test "list virtual environments with hit prefix" {
  stub govenv-version-name ": echo venv33"
  stub govenv-virtualenv-prefix "2.7.6 : false"
  stub govenv-virtualenv-prefix "3.3.3 : false"
  stub govenv-virtualenv-prefix "venv27 : echo \"/usr\""
  stub govenv-virtualenv-prefix "venv33 : echo \"/usr\""

  run govenv-virtualenvs

  assert_success
  assert_output <<OUT
  venv27 (created from /usr)
* venv33 (created from /usr)
OUT

  unstub govenv-version-name
  unstub govenv-virtualenv-prefix
}

@test "list virtual environments with --bare" {
  stub govenv-virtualenv-prefix "2.7.6 : false"
  stub govenv-virtualenv-prefix "3.3.3 : false"
  stub govenv-virtualenv-prefix "venv27 : echo \"/usr\""
  stub govenv-virtualenv-prefix "venv33 : echo \"/usr\""

  run govenv-virtualenvs --bare

  assert_success
  assert_output <<OUT
venv27
venv33
OUT

  unstub govenv-virtualenv-prefix
}
