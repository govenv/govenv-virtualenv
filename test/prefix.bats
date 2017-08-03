#!/usr/bin/env bats

load test_helper

setup() {
  export GOVENV_ROOT="${TMP}/govenv"
}

create_version() {
  mkdir -p "${GOVENV_ROOT}/versions/$1/bin"
  touch "${GOVENV_ROOT}/versions/$1/bin/python"
  chmod +x "${GOVENV_ROOT}/versions/$1/bin/python"
}

remove_version() {
  rm -fr "${GOVENV_ROOT}/versions/$1"
}

create_virtualenv() {
  create_version "$1"
  create_version "${2:-$1}"
  mkdir -p "${GOVENV_ROOT}/versions/$1/lib/python${2:-$1}"
  echo "${GOVENV_ROOT}/versions/${2:-$1}" > "${GOVENV_ROOT}/versions/$1/lib/python${2:-$1}/orig-prefix.txt"
  touch "${GOVENV_ROOT}/versions/$1/bin/activate"
}

create_virtualenv_jython() {
  create_version "$1"
  create_version "${2:-$1}"
  mkdir -p "${GOVENV_ROOT}/versions/$1/Lib/"
  echo "${GOVENV_ROOT}/versions/${2:-$1}" > "${GOVENV_ROOT}/versions/$1/Lib/orig-prefix.txt"
  touch "${GOVENV_ROOT}/versions/$1/bin/activate"
}

create_virtualenv_pypy() {
  create_version "$1"
  create_version "${2:-$1}"
  mkdir -p "${GOVENV_ROOT}/versions/$1/lib-python/${2:-$1}"
  echo "${GOVENV_ROOT}/versions/${2:-$1}" > "${GOVENV_ROOT}/versions/$1/lib-python/${2:-$1}/orig-prefix.txt"
  touch "${GOVENV_ROOT}/versions/$1/bin/activate"
}

remove_virtualenv() {
  remove_version "$1"
  remove_version "${2:-$1}"
}

create_m_venv() {
  create_version "$1"
  create_version "${2:-$1}"
  echo "home = ${GOVENV_ROOT}/versions/${2:-$1}/bin" > "${GOVENV_ROOT}/versions/$1/pyvenv.cfg"
  touch "${GOVENV_ROOT}/versions/$1/bin/activate"
}

remove_m_venv() {
  remove_version "${2:-$1}"
}

create_conda() {
  create_version "$1"
  create_version "${2:-$1}"
  touch "${GOVENV_ROOT}/versions/$1/bin/conda"
  touch "${GOVENV_ROOT}/versions/$1/bin/activate"
  mkdir -p "${GOVENV_ROOT}/versions/${2:-$1}/bin"
  touch "${GOVENV_ROOT}/versions/${2:-$1}/bin/conda"
  touch "${GOVENV_ROOT}/versions/${2:-$1}/bin/activate"
}

remove_conda() {
  remove_version "${2:-$1}"
}

@test "display prefix of virtualenv created by virtualenv" {
  stub govenv-version-name "echo foo"
  stub govenv-prefix "foo : echo \"${GOVENV_ROOT}/versions/foo\""
  create_virtualenv "foo" "2.7.11"

  GOVENV_VERSION="foo" run govenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
${GOVENV_ROOT}/versions/2.7.11
OUT

  unstub govenv-version-name
  unstub govenv-prefix
  remove_virtualenv "foo" "2.7.11"
}

@test "display prefix of virtualenv created by virtualenv (pypy)" {
  stub govenv-version-name "echo foo"
  stub govenv-prefix "foo : echo \"${GOVENV_ROOT}/versions/foo\""
  create_virtualenv_pypy "foo" "pypy-4.0.1"

  GOVENV_VERSION="foo" run govenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
${GOVENV_ROOT}/versions/pypy-4.0.1
OUT

  unstub govenv-version-name
  unstub govenv-prefix
  remove_virtualenv "foo" "pypy-4.0.1"
}

@test "display prefix of virtualenv created by virtualenv (jython)" {
  stub govenv-version-name "echo foo"
  stub govenv-prefix "foo : echo \"${GOVENV_ROOT}/versions/foo\""
  create_virtualenv_jython "foo" "jython-2.7.0"

  GOVENV_VERSION="foo" run govenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
${GOVENV_ROOT}/versions/jython-2.7.0
OUT

  unstub govenv-version-name
  unstub govenv-prefix
  remove_virtualenv "foo" "jython-2.7.0"
}

@test "display prefixes of virtualenv created by virtualenv" {
  stub govenv-version-name "echo foo:bar"
  stub govenv-prefix "foo : echo \"${GOVENV_ROOT}/versions/foo\"" \
                    "bar : echo \"${GOVENV_ROOT}/versions/bar\""
  create_virtualenv "foo" "2.7.11"
  create_virtualenv "bar" "3.5.1"

  GOVENV_VERSION="foo:bar" run govenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
${GOVENV_ROOT}/versions/2.7.11:${GOVENV_ROOT}/versions/3.5.1
OUT

  unstub govenv-version-name
  unstub govenv-prefix
  remove_virtualenv "foo" "2.7.11"
  remove_virtualenv "bar" "3.5.1"
}

@test "display prefix of virtualenv created by venv" {
  stub govenv-version-name "echo foo"
  stub govenv-prefix "foo : echo \"${GOVENV_ROOT}/versions/foo\""
  create_m_venv "foo" "3.3.6"

  GOVENV_VERSION="foo" run govenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
${GOVENV_ROOT}/versions/3.3.6
OUT

  unstub govenv-version-name
  unstub govenv-prefix
  remove_m_venv "foo" "3.3.6"
}

@test "display prefixes of virtualenv created by venv" {
  stub govenv-version-name "echo foo:bar"
  stub govenv-prefix "foo : echo \"${GOVENV_ROOT}/versions/foo\"" \
                    "bar : echo \"${GOVENV_ROOT}/versions/bar\""
  create_m_venv "foo" "3.3.6"
  create_m_venv "bar" "3.4.4"

  GOVENV_VERSION="foo:bar" run govenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
${GOVENV_ROOT}/versions/3.3.6:${GOVENV_ROOT}/versions/3.4.4
OUT

  unstub govenv-version-name
  unstub govenv-prefix
  remove_m_venv "foo" "3.3.6"
  remove_m_venv "bar" "3.4.4"
}

@test "display prefix of virtualenv created by conda" {
  stub govenv-version-name "echo miniconda3-3.16.0/envs/foo"
  stub govenv-prefix "miniconda3-3.16.0/envs/foo : echo \"${GOVENV_ROOT}/versions/miniconda3-3.16.0/envs/foo\""
  create_conda "miniconda3-3.16.0/envs/foo" "miniconda3-3.16.0"

  GOVENV_VERSION="miniconda3-3.16.0/envs/foo" run govenv-virtualenv-prefix

  assert_success
  assert_output <<OUT
${GOVENV_ROOT}/versions/miniconda3-3.16.0/envs/foo
OUT

  unstub govenv-version-name
  unstub govenv-prefix
  remove_conda "miniconda3-3.16.0/envs/foo" "miniconda3-3.16.0"
}

@test "should fail if the version is the system" {
  stub govenv-version-name "echo system"

  GOVENV_VERSION="system" run govenv-virtualenv-prefix

  assert_failure
  assert_output <<OUT
govenv-virtualenv: version \`system' is not a virtualenv
OUT

  unstub govenv-version-name
}

@test "should fail if the version is not a virtualenv" {
  stub govenv-version-name "echo 3.4.4"
  stub govenv-prefix "3.4.4 : echo \"${GOVENV_ROOT}/versions/3.4.4\""
  create_version "3.4.4"

  GOVENV_VERSION="3.4.4" run govenv-virtualenv-prefix

  assert_failure
  assert_output <<OUT
govenv-virtualenv: version \`3.4.4' is not a virtualenv
OUT

  unstub govenv-version-name
  unstub govenv-prefix
  remove_version "3.4.4"
}

@test "should fail if one of the versions is not a virtualenv" {
  stub govenv-version-name "echo venv33:3.4.4"
  stub govenv-prefix "venv33 : echo \"${GOVENV_ROOT}/versions/venv33\"" \
                    "3.4.4 : echo \"${GOVENV_ROOT}/versions/3.4.4\""
  create_virtualenv "venv33" "3.3.6"
  create_version "3.4.4"

  GOVENV_VERSION="venv33:3.4.4" run govenv-virtualenv-prefix

  assert_failure
  assert_output <<OUT
govenv-virtualenv: version \`3.4.4' is not a virtualenv
OUT

  unstub govenv-version-name
  unstub govenv-prefix
  remove_virtualenv "venv33" "3.3.6"
  remove_version "3.4.4"
}
