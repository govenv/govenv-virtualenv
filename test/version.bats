#!/usr/bin/env bats

load test_helper

setup() {
  export GOVENV_ROOT="${TMP}/govenv"
}

@test "display virtualenv version" {
  setup_virtualenv "2.7.7"
  stub govenv-prefix "echo '${GOVENV_ROOT}/versions/2.7.7'"
  stub govenv-exec "python -m venv --help : false"
  stub govenv-exec "virtualenv --version : echo \"1.11\""

  run govenv-virtualenv --version

  assert_success
  [[ "$output" == "govenv-virtualenv "?.?.?" (virtualenv 1.11)" ]]

  unstub govenv-prefix
  unstub govenv-exec
  teardown_virtualenv "2.7.7"
}

@test "display venv version" {
  setup_m_venv "3.4.1"
  stub govenv-prefix "echo '${GOVENV_ROOT}/versions/3.4.1'"
  stub govenv-exec "python -m venv --help : true"

  run govenv-virtualenv --version

  assert_success
  [[ "$output" == "govenv-virtualenv "?.?.?" (python -m venv)" ]]

  unstub govenv-prefix
  teardown_m_venv "3.4.1"
}
