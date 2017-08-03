#!/usr/bin/env bats

load test_helper

setup() {
  export GOVENV_ROOT="${TMP}/envs/govenv"
}

stub_govenv() {
  stub govenv-prefix " : echo '${GOVENV_ROOT}/versions/${GOVENV_VERSION}'"
  stub govenv-hooks "virtualenv : echo"
  stub govenv-rehash " : echo rehashed"
}

unstub_govenv() {
  unstub govenv-prefix
  unstub govenv-hooks
  unstub govenv-rehash
}

@test "path should be handled properly even if there is 'envs' in GOVENV_ROOT" {
  export GOVENV_VERSION="3.5.1"
  setup_m_venv "3.5.1"
  stub_govenv "${GOVENV_VERSION}"
  stub govenv-version-name "echo '${GOVENV_VERSION}'"
  stub govenv-prefix " : echo '${GOVENV_ROOT}/versions/${GOVENV_VERSION}'"
  stub govenv-virtualenv-prefix " : false"
  stub govenv-exec "python -m venv --help : true"
  stub govenv-exec "python -m venv * : echo GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\";mkdir -p \${GOVENV_ROOT}/versions/3.5.1/envs/venv/bin"
  stub govenv-exec "python -s -m ensurepip : echo GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\";touch \${GOVENV_ROOT}/versions/3.5.1/envs/venv/bin/pip"

  run govenv-virtualenv venv

  assert_success
  assert_output <<OUT
GOVENV_VERSION=3.5.1 python -m venv ${GOVENV_ROOT}/versions/3.5.1/envs/venv
GOVENV_VERSION=3.5.1/envs/venv python -s -m ensurepip
rehashed
OUT
  assert [ -e "${GOVENV_ROOT}/versions/3.5.1/envs/venv/bin/pip" ]

  unstub_govenv
  unstub govenv-version-name
  unstub govenv-virtualenv-prefix
  unstub govenv-exec
  teardown_m_venv "3.5.1"
}
