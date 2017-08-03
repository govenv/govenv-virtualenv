#!/usr/bin/env bats

load test_helper

setup() {
  export GOVENV_ROOT="${TMP}/govenv"
}

stub_govenv() {
  setup_version "${GOVENV_VERSION}"
  create_executable "${GOVENV_VERSION}" "virtualenv"
  stub govenv-prefix "echo '${GOVENV_ROOT}/versions/${GOVENV_VERSION}'"
  stub govenv-prefix "echo '${GOVENV_ROOT}/versions/${GOVENV_VERSION}'"
  stub govenv-hooks "virtualenv : echo"
  stub govenv-rehash " : echo rehashed"
}

unstub_govenv() {
  unstub govenv-prefix
  unstub govenv-hooks
  unstub govenv-rehash
  teardown_version "${GOVENV_VERSION}"
}

@test "create virtualenv from given version" {
  export GOVENV_VERSION="2.7.11"
  stub_govenv "${GOVENV_VERSION}"
  stub govenv-virtualenv-prefix " : false"
  stub govenv-exec "python -m venv --help : false"
  stub govenv-exec "virtualenv * : echo GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\""
  stub govenv-exec "python -s -m ensurepip : false"
  stub govenv-exec "python -s */get-pip.py : true"
  stub curl true

  run govenv-virtualenv "2.7.11" "venv"

  assert_success
  assert_output <<OUT
GOVENV_VERSION=2.7.11 virtualenv ${GOVENV_ROOT}/versions/2.7.11/envs/venv
Installing pip from https://bootstrap.pypa.io/get-pip.py...
rehashed
OUT

  unstub_govenv
  unstub govenv-virtualenv-prefix
  unstub govenv-exec
  unstub curl
}

@test "create virtualenv from current version" {
  export GOVENV_VERSION="2.7.11"
  stub_govenv "${GOVENV_VERSION}"
  stub govenv-version-name "echo \${GOVENV_VERSION}"
  stub govenv-virtualenv-prefix " : false"
  stub govenv-exec "python -m venv --help : false"
  stub govenv-exec "virtualenv * : echo GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\""
  stub govenv-exec "python -s -m ensurepip : false"
  stub govenv-exec "python -s */get-pip.py : true"
  stub curl true

  run govenv-virtualenv venv

  assert_success
  assert_output <<OUT
GOVENV_VERSION=2.7.11 virtualenv ${GOVENV_ROOT}/versions/2.7.11/envs/venv
Installing pip from https://bootstrap.pypa.io/get-pip.py...
rehashed
OUT

  unstub_govenv
  unstub govenv-version-name
  unstub govenv-virtualenv-prefix
  unstub govenv-exec
  unstub curl
}

@test "create virtualenv with short options" {
  export GOVENV_VERSION="2.7.11"
  stub_govenv "${GOVENV_VERSION}"
  stub govenv-version-name "echo \${GOVENV_VERSION}"
  stub govenv-virtualenv-prefix " : false"
  stub govenv-exec "python -m venv --help : false"
  stub govenv-exec "virtualenv * : echo GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\""
  stub govenv-exec "python -s -m ensurepip : false"
  stub govenv-exec "python -s */get-pip.py : true"
  stub curl true

  run govenv-virtualenv -v -p ${TMP}/python venv

  assert_output <<OUT
GOVENV_VERSION=2.7.11 virtualenv --verbose --python=${TMP}/python ${GOVENV_ROOT}/versions/2.7.11/envs/venv
Installing pip from https://bootstrap.pypa.io/get-pip.py...
rehashed
OUT
  assert_success

  unstub_govenv
  unstub govenv-version-name
  unstub govenv-virtualenv-prefix
  unstub govenv-exec
  unstub curl
}

@test "create virtualenv with long options" {
  export GOVENV_VERSION="2.7.11"
  stub_govenv "${GOVENV_VERSION}"
  stub govenv-version-name "echo \${GOVENV_VERSION}"
  stub govenv-virtualenv-prefix " : false"
  stub govenv-exec "python -m venv --help : false"
  stub govenv-exec "virtualenv * : echo GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\""
  stub govenv-exec "python -s -m ensurepip : false"
  stub govenv-exec "python -s */get-pip.py : true"
  stub curl true

  run govenv-virtualenv --verbose --python=${TMP}/python venv

  assert_output <<OUT
GOVENV_VERSION=2.7.11 virtualenv --verbose --python=${TMP}/python ${GOVENV_ROOT}/versions/2.7.11/envs/venv
Installing pip from https://bootstrap.pypa.io/get-pip.py...
rehashed
OUT
  assert_success

  unstub_govenv
  unstub govenv-version-name
  unstub govenv-virtualenv-prefix
  unstub govenv-exec
  unstub curl
}

@test "no whitespace allowed in virtualenv name" {
  run govenv-virtualenv "2.7.11" "foo bar"

  assert_failure
  assert_output <<OUT
govenv-virtualenv: no whitespace allowed in virtualenv name.
OUT
}

@test "no tab allowed in virtualenv name" {
  run govenv-virtualenv "2.7.11" "foo	bar baz"

  assert_failure
  assert_output <<OUT
govenv-virtualenv: no whitespace allowed in virtualenv name.
OUT
}

@test "system not allowed as virtualenv name" {
  run govenv-virtualenv "2.7.11" "system"

  assert_failure
  assert_output <<OUT
govenv-virtualenv: \`system' is not allowed as virtualenv name.
OUT
}

@test "no slash allowed in virtualenv name" {
  run govenv-virtualenv "2.7.11" "foo/bar"

  assert_failure
  assert_output <<OUT
govenv-virtualenv: no slash allowed in virtualenv name.
OUT
}

@test "slash allowed if it is the long name of the virtualenv" {
  export GOVENV_VERSION="2.7.11"
  stub_govenv "${GOVENV_VERSION}"
  stub govenv-virtualenv-prefix " : false"
  stub govenv-exec "python -m venv --help : false"
  stub govenv-exec "virtualenv * : echo GOVENV_VERSION=\${GOVENV_VERSION} \"\$@\""
  stub govenv-exec "python -s -m ensurepip : false"
  stub govenv-exec "python -s */get-pip.py : true"
  stub curl true

  run govenv-virtualenv "2.7.11" "2.7.11/envs/foo"

  assert_success
  assert_output <<OUT
GOVENV_VERSION=2.7.11 virtualenv ${GOVENV_ROOT}/versions/2.7.11/envs/foo
Installing pip from https://bootstrap.pypa.io/get-pip.py...
rehashed
OUT

  unstub_govenv
  unstub govenv-virtualenv-prefix
  unstub govenv-exec
  unstub curl
}
