#!/usr/bin/env bats

load test_helper

@test "detect parent shell" {
  unset GOVENV_SHELL
  SHELL=/bin/false run govenv-virtualenv-init -
  assert_success
  assert_output_contains '  PROMPT_COMMAND="_govenv_virtualenv_hook;$PROMPT_COMMAND";'
}

@test "detect parent shell from script (sh)" {
  unset GOVENV_SHELL
  printf '#!/bin/sh\necho "$(govenv-virtualenv-init -)"' > "${TMP}/script.sh"
  chmod +x ${TMP}/script.sh
  run ${TMP}/script.sh
  assert_success
  assert_output_contains_not '  PROMPT_COMMAND="_govenv_virtualenv_hook;$PROMPT_COMMAND";'
  rm -f "${TMP}/script.sh"
}

@test "detect parent shell from script (bash)" {
  unset GOVENV_SHELL
  printf '#!/bin/bash\necho "$(govenv-virtualenv-init -)"' > "${TMP}/script.sh"
  chmod +x ${TMP}/script.sh
  run ${TMP}/script.sh
  assert_success
  assert_output_contains '  PROMPT_COMMAND="_govenv_virtualenv_hook;$PROMPT_COMMAND";'
  rm -f "${TMP}/script.sh"
}

@test "sh-compatible instructions" {
  run govenv-virtualenv-init bash
  assert [ "$status" -eq 1 ]
  assert_output_contains 'eval "$(govenv virtualenv-init -)"'

  run govenv-virtualenv-init zsh
  assert [ "$status" -eq 1 ]
  assert_output_contains 'eval "$(govenv virtualenv-init -)"'
}

@test "fish instructions" {
  run govenv-virtualenv-init fish
  assert [ "$status" -eq 1 ]
  assert_output_contains 'status --is-interactive; and source (govenv virtualenv-init -|psub)'
}

@test "outputs bash-specific syntax" {
  export GOVENV_VIRTUALENV_ROOT="${TMP}/govenv/plugins/govenv-virtualenv"
  run govenv-virtualenv-init - bash
  assert_success
  assert_output <<EOS
export PATH="${TMP}/govenv/plugins/govenv-virtualenv/shims:\${PATH}";
export GOVENV_VIRTUALENV_INIT=1;
_govenv_virtualenv_hook() {
  local ret=\$?
  if [ -n "\$VIRTUAL_ENV" ]; then
    eval "\$(govenv sh-activate --quiet || govenv sh-deactivate --quiet || true)" || true
  else
    eval "\$(govenv sh-activate --quiet || true)" || true
  fi
  return \$ret
};
if ! [[ "\$PROMPT_COMMAND" =~ _govenv_virtualenv_hook ]]; then
  PROMPT_COMMAND="_govenv_virtualenv_hook;\$PROMPT_COMMAND";
fi
EOS
}

@test "outputs fish-specific syntax" {
  export GOVENV_VIRTUALENV_ROOT="${TMP}/govenv/plugins/govenv-virtualenv"
  run govenv-virtualenv-init - fish
  assert_success
  assert_output <<EOS
set -gx PATH '${TMP}/govenv/plugins/govenv-virtualenv/shims' \$PATH;
set -gx GOVENV_VIRTUALENV_INIT 1;
function _govenv_virtualenv_hook --on-event fish_prompt;
  set -l ret \$status
  if [ -n "\$VIRTUAL_ENV" ]
    govenv activate --quiet; or govenv deactivate --quiet; or true
  else
    govenv activate --quiet; or true
  end
  return \$ret
end
EOS
}

@test "outputs zsh-specific syntax" {
  export GOVENV_VIRTUALENV_ROOT="${TMP}/govenv/plugins/govenv-virtualenv"
  run govenv-virtualenv-init - zsh
  assert_success
  assert_output <<EOS
export PATH="${TMP}/govenv/plugins/govenv-virtualenv/shims:\${PATH}";
export GOVENV_VIRTUALENV_INIT=1;
_govenv_virtualenv_hook() {
  local ret=\$?
  if [ -n "\$VIRTUAL_ENV" ]; then
    eval "\$(govenv sh-activate --quiet || govenv sh-deactivate --quiet || true)" || true
  else
    eval "\$(govenv sh-activate --quiet || true)" || true
  fi
  return \$ret
};
typeset -g -a precmd_functions
if [[ -z \$precmd_functions[(r)_govenv_virtualenv_hook] ]]; then
  precmd_functions=(_govenv_virtualenv_hook \$precmd_functions);
fi
EOS
}
