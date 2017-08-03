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

@test "use venv if virtualenv is not available" {
  export GOVENV_VERSION="3.5.1"
  setup_m_venv "3.5.1"
  stub_govenv "${GOVENV_VERSION}"
  stub govenv-prefix " : echo '${GOVENV_ROOT}/versions/${GOVENV_VERSION}'"
  stub govenv-virtualenv-prefix " : false"
  stub govenv-exec "python -m venv --help : true"
  stub govenv-exec "python -m venv * : echo GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\""
  stub govenv-exec "python -s -m ensurepip : true"

  run govenv-virtualenv venv

  assert_success
  assert_output <<OUT
GOVENV_VERSION=3.5.1 python -m venv ${GOVENV_ROOT}/versions/3.5.1/envs/venv
rehashed
OUT

  unstub_govenv
  unstub govenv-virtualenv-prefix
  unstub govenv-exec
  teardown_m_venv "3.5.1"
}

@test "not use venv if virtualenv is available" {
  export GOVENV_VERSION="3.5.1"
  setup_m_venv "3.5.1"
  create_executable "3.5.1" "virtualenv"
  stub_govenv "${GOVENV_VERSION}"
  stub govenv-prefix " : echo '${GOVENV_ROOT}/versions/${GOVENV_VERSION}'"
  stub govenv-virtualenv-prefix " : false"
  stub govenv-exec "python -m venv --help : true"
  stub govenv-exec "virtualenv * : echo GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\""
  stub govenv-exec "python -s -m ensurepip : true"

  run govenv-virtualenv venv

  assert_success
  assert_output <<OUT
GOVENV_VERSION=3.5.1 virtualenv ${GOVENV_ROOT}/versions/3.5.1/envs/venv
rehashed
OUT

  unstub_govenv
  unstub govenv-virtualenv-prefix
  unstub govenv-exec
  teardown_m_venv "3.5.1"
}

@test "install virtualenv if venv is not avaialble" {
  export GOVENV_VERSION="3.2.1"
  setup_version "3.2.1"
  stub_govenv "${GOVENV_VERSION}"
  stub govenv-prefix " : echo '${GOVENV_ROOT}/versions/${GOVENV_VERSION}'"
  stub govenv-virtualenv-prefix " : false"
  stub govenv-exec "python -m venv --help : false"
  stub govenv-exec "pip install virtualenv* : echo GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\""
  stub govenv-exec "virtualenv * : echo GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\""

  run govenv-virtualenv venv

  assert_success
  assert_output <<OUT
GOVENV_VERSION=3.2.1 pip install virtualenv==13.1.2
GOVENV_VERSION=3.2.1 virtualenv ${GOVENV_ROOT}/versions/3.2.1/envs/venv
rehashed
OUT

  unstub_govenv
  unstub govenv-virtualenv-prefix
  unstub govenv-exec
  teardown_version "3.2.1"
}

@test "install virtualenv if -p has given" {
  export GOVENV_VERSION="3.5.1"
  setup_m_venv "3.5.1"
  stub_govenv "${GOVENV_VERSION}"
  stub govenv-prefix " : echo '${GOVENV_ROOT}/versions/${GOVENV_VERSION}'"
  stub govenv-virtualenv-prefix " : false"
  stub govenv-exec "python -m venv --help : true"
  stub govenv-exec "pip install virtualenv : echo GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\""
  stub govenv-exec "virtualenv * : echo GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\""
  stub govenv-exec "python -s -m ensurepip : true"

  run govenv-virtualenv -p ${TMP}/python3 venv

  assert_output <<OUT
GOVENV_VERSION=3.5.1 pip install virtualenv
GOVENV_VERSION=3.5.1 virtualenv --python=${TMP}/python3 ${GOVENV_ROOT}/versions/3.5.1/envs/venv
rehashed
OUT
  assert_success

  unstub_govenv
  unstub govenv-virtualenv-prefix
  unstub govenv-exec
  teardown_m_venv "3.5.1"
}

@test "install virtualenv if --python has given" {
  export GOVENV_VERSION="3.5.1"
  setup_m_venv "3.5.1"
  stub_govenv "${GOVENV_VERSION}"
  stub govenv-prefix " : echo '${GOVENV_ROOT}/versions/${GOVENV_VERSION}'"
  stub govenv-virtualenv-prefix " : false"
  stub govenv-exec "python -m venv --help : true"
  stub govenv-exec "pip install virtualenv : echo GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\""
  stub govenv-exec "virtualenv * : echo GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\""
  stub govenv-exec "python -s -m ensurepip : true"

  run govenv-virtualenv --python=${TMP}/python3 venv

  assert_output <<OUT
GOVENV_VERSION=3.5.1 pip install virtualenv
GOVENV_VERSION=3.5.1 virtualenv --python=${TMP}/python3 ${GOVENV_ROOT}/versions/3.5.1/envs/venv
rehashed
OUT
  assert_success

  unstub_govenv
  unstub govenv-virtualenv-prefix
  unstub govenv-exec
  teardown_m_venv "3.5.1"
}

@test "install virtualenv with unsetting troublesome pip options" {
  export GOVENV_VERSION="3.2.1"
  setup_version "3.2.1"
  stub_govenv "${GOVENV_VERSION}"
  stub govenv-prefix " : echo '${GOVENV_ROOT}/versions/${GOVENV_VERSION}'"
  stub govenv-virtualenv-prefix " : false"
  stub govenv-exec "python -m venv --help : false"
  stub govenv-exec "pip install virtualenv* : echo PIP_REQUIRE_VENV=\${PIP_REQUIRE_VENV} GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\""
  stub govenv-exec "virtualenv * : echo PIP_REQUIRE_VENV=\${PIP_REQUIRE_VENV} GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\""

  PIP_REQUIRE_VENV="true" run govenv-virtualenv venv

  assert_success
  assert_output <<OUT
PIP_REQUIRE_VENV= GOVENV_VERSION=3.2.1 pip install virtualenv==13.1.2
PIP_REQUIRE_VENV= GOVENV_VERSION=3.2.1 virtualenv ${GOVENV_ROOT}/versions/3.2.1/envs/venv
rehashed
OUT

  unstub_govenv
  unstub govenv-virtualenv-prefix
  unstub govenv-exec
  teardown_version "3.2.1"
}
