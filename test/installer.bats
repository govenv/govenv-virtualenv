#!/usr/bin/env bats

load test_helper

@test "installs govenv-virtualenv into PREFIX" {
  cd "$TMP"
  PREFIX="${PWD}/usr" run "${BATS_TEST_DIRNAME}/../install.sh"
  assert_success ""

  cd usr

  assert [ -x bin/govenv-activate ]
  assert [ -x bin/govenv-deactivate ]
  assert [ -x bin/govenv-sh-activate ]
  assert [ -x bin/govenv-sh-deactivate ]
  assert [ -x bin/govenv-virtualenv ]
  assert [ -x bin/govenv-virtualenv-init ]
  assert [ -x bin/govenv-virtualenv-prefix ]
  assert [ -x bin/govenv-virtualenvs ]
}

@test "overwrites old installation" {
  cd "$TMP"
  mkdir -p bin
  touch bin/govenv-virtualenv

  PREFIX="$PWD" run "${BATS_TEST_DIRNAME}/../install.sh"
  assert_success ""

  assert [ -x bin/govenv-virtualenv ]
  run grep "virtualenv" bin/govenv-virtualenv
  assert_success
}

@test "unrelated files are untouched" {
  cd "$TMP"
  mkdir -p bin share/bananas
  chmod g-w bin
  touch bin/bananas

  PREFIX="$PWD" run "${BATS_TEST_DIRNAME}/../install.sh"
  assert_success ""

  assert [ -e bin/bananas ]

  run ls -ld bin
  assert_equal "r-x" "${output:4:3}"
}
