#!/usr/bin/env bats

load test_helper

setup() {
  export GOVENV_ROOT="${TMP}/govenv"
}

@test "display conda root" {
  setup_conda "anaconda-2.3.0"
  stub govenv-version-name "echo anaconda-2.3.0"
  stub govenv-prefix "anaconda-2.3.0 : echo \"${GOVENV_ROOT}/versions/anaconda-2.3.0\""

  GOVENV_VERSION="anaconda-2.3.0" run govenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
${GOVENV_ROOT}/versions/anaconda-2.3.0
OUT

  unstub govenv-version-name
  unstub govenv-prefix
  teardown_conda "anaconda-2.3.0"
}

@test "display conda env" {
  setup_conda "anaconda-2.3.0" "foo"
  stub govenv-version-name "echo anaconda-2.3.0/envs/foo"
  stub govenv-prefix "anaconda-2.3.0/envs/foo : echo \"${GOVENV_ROOT}/versions/anaconda-2.3.0/envs/foo\""

  GOVENV_VERSION="anaconda-2.3.0/envs/foo" run govenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
${GOVENV_ROOT}/versions/anaconda-2.3.0/envs/foo
OUT

  unstub govenv-version-name
  unstub govenv-prefix
  teardown_conda "anaconda-2.3.0" "foo"
}
