#!/usr/bin/env bats

load test_helper

setup() {
  export GOVENV_ROOT="${TMP}/govenv"
  export HOOK_PATH="${TMP}/i has hooks"
  mkdir -p "$HOOK_PATH"
}

@test "govenv-virtualenv hooks" {
  cat > "${HOOK_PATH}/virtualenv.bash" <<OUT
before_virtualenv 'echo before: \$VIRTUALENV_PATH'
after_virtualenv 'echo after: \$STATUS'
OUT
  setup_version "3.5.1"
  create_executable "3.5.1" "virtualenv"
  stub govenv-prefix "echo '${GOVENV_ROOT}/versions/3.5.1'"
  stub govenv-prefix "echo '${GOVENV_ROOT}/versions/3.5.1'"
  stub govenv-exec "python -m venv --help : true"
  stub govenv-hooks "virtualenv : echo '$HOOK_PATH'/virtualenv.bash"
  stub govenv-exec "echo GOVENV_VERSION=3.5.1 \"\$@\""
  stub govenv-exec "echo GOVENV_VERSION=3.5.1 \"\$@\""
  stub govenv-rehash "echo rehashed"

  run govenv-virtualenv "3.5.1" venv

  assert_success
  assert_output <<-OUT
before: ${GOVENV_ROOT}/versions/3.5.1/envs/venv
GOVENV_VERSION=3.5.1 virtualenv ${GOVENV_ROOT}/versions/3.5.1/envs/venv
GOVENV_VERSION=3.5.1 python -s -m ensurepip
after: 0
rehashed
OUT

  unstub govenv-prefix
  unstub govenv-hooks
  unstub govenv-exec
  unstub govenv-rehash
  teardown_version "3.5.1"
}
