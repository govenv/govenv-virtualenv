#!/usr/bin/env bats

load test_helper

setup() {
  export GOVENV_ROOT="${TMP}/govenv"
}

stub_govenv() {
  stub govenv-version-name "echo \${GOVENV_VERSION}"
  stub govenv-prefix " : echo '${GOVENV_ROOT}/versions/${GOVENV_VERSION}'"
  stub govenv-hooks "virtualenv : echo"
  stub govenv-rehash " : echo rehashed"
}

unstub_govenv() {
  unstub govenv-version-name
  unstub govenv-prefix
  unstub govenv-hooks
  unstub govenv-rehash
}

@test "create virtualenv by conda create" {
  export GOVENV_VERSION="miniconda3-3.16.0"
  setup_conda "${GOVENV_VERSION}"
  stub_govenv "${GOVENV_VERSION}"
  stub govenv-prefix " : echo '${GOVENV_ROOT}/versions/${GOVENV_VERSION}'"
  stub govenv-virtualenv-prefix " : echo '${GOVENV_ROOT}/versions/${GOVENV_VERSION}'"
  stub govenv-exec "conda * : echo GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\""
  stub govenv-exec "python -s -m ensurepip : true"

  run govenv-virtualenv venv

  assert_success
  assert_output <<OUT
GOVENV_VERSION=miniconda3-3.16.0 conda create --name venv --yes python
rehashed
OUT

  unstub_govenv
  unstub govenv-virtualenv-prefix
  unstub govenv-exec
  teardown_m_venv "miniconda3-3.16.0"
}

@test "create virtualenv by conda create with -p" {
  export GOVENV_VERSION="miniconda3-3.16.0"
  setup_conda "${GOVENV_VERSION}"
  stub_govenv "${GOVENV_VERSION}"
  stub govenv-prefix " : echo '${GOVENV_ROOT}/versions/${GOVENV_VERSION}'"
  stub govenv-virtualenv-prefix " : echo '${GOVENV_ROOT}/versions/${GOVENV_VERSION}'"
  stub govenv-exec "conda * : echo GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\""
  stub govenv-exec "python -s -m ensurepip : true"

  run govenv-virtualenv -p python3.5 venv

  assert_success
  assert_output <<OUT
GOVENV_VERSION=miniconda3-3.16.0 conda create --name venv --yes python=3.5 python
rehashed
OUT

  unstub_govenv
  unstub govenv-virtualenv-prefix
  unstub govenv-exec
  teardown_m_venv "miniconda3-3.16.0"
}

@test "create virtualenv by conda create with --python" {
  export GOVENV_VERSION="miniconda3-3.16.0"
  setup_conda "${GOVENV_VERSION}"
  stub_govenv "${GOVENV_VERSION}"
  stub govenv-prefix " : echo '${GOVENV_ROOT}/versions/${GOVENV_VERSION}'"
  stub govenv-virtualenv-prefix " : echo '${GOVENV_ROOT}/versions/${GOVENV_VERSION}'"
  stub govenv-exec "conda * : echo GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\""
  stub govenv-exec "python -s -m ensurepip : true"

  run govenv-virtualenv --python=python3.5 venv

  assert_success
  assert_output <<OUT
GOVENV_VERSION=miniconda3-3.16.0 conda create --name venv --yes python=3.5 python
rehashed
OUT

  unstub_govenv
  unstub govenv-virtualenv-prefix
  unstub govenv-exec
  teardown_m_venv "miniconda3-3.16.0"
}
