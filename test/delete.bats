#!/usr/bin/env bats

load test_helper

setup() {
  export GOVENV_ROOT="${TMP}/govenv"
}

@test "delete virtualenv" {
  mkdir -p "${GOVENV_ROOT}/versions/venv27"

  stub govenv-virtualenv-prefix "venv27 : true"
  stub govenv-rehash "true"

  run govenv-virtualenv-delete -f "venv27"

  assert_success

  unstub govenv-virtualenv-prefix
  unstub govenv-rehash

  [ ! -d "${GOVENV_ROOT}/versions/venv27" ]
}

@test "delete virtualenv by symlink" {
  mkdir -p "${GOVENV_ROOT}/versions/2.7.11/envs/venv27"
  ln -fs "${GOVENV_ROOT}/versions/2.7.11/envs/venv27" "${GOVENV_ROOT}/versions/venv27"

  stub govenv-rehash "true"

  run govenv-virtualenv-delete -f "venv27"

  assert_success

  unstub govenv-rehash

  [ ! -d "${GOVENV_ROOT}/versions/2.7.11/envs/venv27" ]
  [ ! -L "${GOVENV_ROOT}/versions/venv27" ]
}

@test "delete virtualenv with symlink" {
  mkdir -p "${GOVENV_ROOT}/versions/2.7.11/envs/venv27"
  ln -fs "${GOVENV_ROOT}/versions/2.7.11/envs/venv27" "${GOVENV_ROOT}/versions/venv27"

  stub govenv-rehash "true"

  run govenv-virtualenv-delete -f "2.7.11/envs/venv27"

  assert_success

  unstub govenv-rehash

  [ ! -d "${GOVENV_ROOT}/versions/2.7.11/envs/venv27" ]
  [ ! -L "${GOVENV_ROOT}/versions/venv27" ]
}

@test "not delete virtualenv with different symlink" {
  mkdir -p "${GOVENV_ROOT}/versions/2.7.8/envs/venv27"
  mkdir -p "${GOVENV_ROOT}/versions/2.7.11/envs/venv27"
  ln -fs "${GOVENV_ROOT}/versions/2.7.8/envs/venv27" "${GOVENV_ROOT}/versions/venv27"

  stub govenv-rehash "true"

  run govenv-virtualenv-delete -f "2.7.11/envs/venv27"

  assert_success

  unstub govenv-rehash

  [ ! -d "${GOVENV_ROOT}/versions/2.7.11/envs/venv27" ]
  [ -L "${GOVENV_ROOT}/versions/venv27" ]
}

@test "not delete virtualenv with same name" {
  mkdir -p "${GOVENV_ROOT}/versions/2.7.11/envs/venv27"
  mkdir -p "${GOVENV_ROOT}/versions/venv27"

  stub govenv-rehash "true"

  run govenv-virtualenv-delete -f "2.7.11/envs/venv27"

  assert_success

  unstub govenv-rehash

  [ ! -d "${GOVENV_ROOT}/versions/2.7.11/envs/venv27" ]
  [ -d "${GOVENV_ROOT}/versions/venv27" ]
}
