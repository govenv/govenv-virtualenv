#!/usr/bin/env bats

load test_helper

setup() {
  export GOVENV_ROOT="${TMP}/govenv"
  unset GOVENV_VERSION
  unset GOVENV_ACTIVATE_SHELL
  unset GOVENV_VIRTUAL_ENV
  unset VIRTUAL_ENV
  unset CONDA_DEFAULT_ENV
  unset PYTHONHOME
  unset _OLD_VIRTUAL_PYTHONHOME
  unset GOVENV_VIRTUALENV_VERBOSE_ACTIVATE
  unset GOVENV_VIRTUALENV_DISABLE_PROMPT
  unset GOVENV_VIRTUAL_ENV_DISABLE_PROMPT
  unset VIRTUAL_ENV_DISABLE_PROMPT
  unset _OLD_VIRTUAL_PS1
}

@test "deactivate virtualenv" {
  export GOVENV_VIRTUALENV_INIT=1
  export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export GOVENV_ACTIVATE_SHELL=

  GOVENV_SHELL="bash" run govenv-sh-deactivate

  assert_success
  assert_output <<EOS
unset GOVENV_VIRTUAL_ENV;
unset VIRTUAL_ENV;
if [ -n "\${_OLD_VIRTUAL_PATH}" ]; then
  export PATH="\${_OLD_VIRTUAL_PATH}";
  unset _OLD_VIRTUAL_PATH;
fi;
if [ -n "\${_OLD_VIRTUAL_PYTHONHOME}" ]; then
  export PYTHONHOME="\${_OLD_VIRTUAL_PYTHONHOME}";
  unset _OLD_VIRTUAL_PYTHONHOME;
fi;
if [ -n "\${_OLD_VIRTUAL_PS1}" ]; then
  export PS1="\${_OLD_VIRTUAL_PS1}";
  unset _OLD_VIRTUAL_PS1;
fi;
if declare -f deactivate 1>/dev/null 2>&1; then
  unset -f deactivate;
fi;
EOS
}

@test "deactivate virtualenv (quiet)" {
  export GOVENV_VIRTUALENV_INIT=1
  export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export GOVENV_ACTIVATE_SHELL=

  GOVENV_SHELL="bash" run govenv-sh-deactivate --quit

  assert_success
  assert_output <<EOS
unset GOVENV_VIRTUAL_ENV;
unset VIRTUAL_ENV;
if [ -n "\${_OLD_VIRTUAL_PATH}" ]; then
  export PATH="\${_OLD_VIRTUAL_PATH}";
  unset _OLD_VIRTUAL_PATH;
fi;
if [ -n "\${_OLD_VIRTUAL_PYTHONHOME}" ]; then
  export PYTHONHOME="\${_OLD_VIRTUAL_PYTHONHOME}";
  unset _OLD_VIRTUAL_PYTHONHOME;
fi;
if [ -n "\${_OLD_VIRTUAL_PS1}" ]; then
  export PS1="\${_OLD_VIRTUAL_PS1}";
  unset _OLD_VIRTUAL_PS1;
fi;
if declare -f deactivate 1>/dev/null 2>&1; then
  unset -f deactivate;
fi;
EOS
}

@test "deactivate virtualenv (verbose)" {
  export GOVENV_VIRTUALENV_INIT=1
  export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export GOVENV_ACTIVATE_SHELL=
  export GOVENV_VIRTUALENV_VERBOSE_ACTIVATE=1

  GOVENV_SHELL="bash" run govenv-sh-deactivate --verbose

  assert_success
  assert_output <<EOS
govenv-virtualenv: deactivate venv
unset GOVENV_VIRTUAL_ENV;
unset VIRTUAL_ENV;
if [ -n "\${_OLD_VIRTUAL_PATH}" ]; then
  export PATH="\${_OLD_VIRTUAL_PATH}";
  unset _OLD_VIRTUAL_PATH;
fi;
if [ -n "\${_OLD_VIRTUAL_PYTHONHOME}" ]; then
  export PYTHONHOME="\${_OLD_VIRTUAL_PYTHONHOME}";
  unset _OLD_VIRTUAL_PYTHONHOME;
fi;
if [ -n "\${_OLD_VIRTUAL_PS1}" ]; then
  export PS1="\${_OLD_VIRTUAL_PS1}";
  unset _OLD_VIRTUAL_PS1;
fi;
if declare -f deactivate 1>/dev/null 2>&1; then
  unset -f deactivate;
fi;
EOS
}

@test "deactivate virtualenv (quiet)" {
  export GOVENV_VIRTUALENV_INIT=1
  export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export GOVENV_ACTIVATE_SHELL=

  GOVENV_SHELL="bash" run govenv-sh-deactivate --quiet

  assert_success
  assert_output <<EOS
unset GOVENV_VIRTUAL_ENV;
unset VIRTUAL_ENV;
if [ -n "\${_OLD_VIRTUAL_PATH}" ]; then
  export PATH="\${_OLD_VIRTUAL_PATH}";
  unset _OLD_VIRTUAL_PATH;
fi;
if [ -n "\${_OLD_VIRTUAL_PYTHONHOME}" ]; then
  export PYTHONHOME="\${_OLD_VIRTUAL_PYTHONHOME}";
  unset _OLD_VIRTUAL_PYTHONHOME;
fi;
if [ -n "\${_OLD_VIRTUAL_PS1}" ]; then
  export PS1="\${_OLD_VIRTUAL_PS1}";
  unset _OLD_VIRTUAL_PS1;
fi;
if declare -f deactivate 1>/dev/null 2>&1; then
  unset -f deactivate;
fi;
EOS
}

@test "deactivate virtualenv (with shell activation)" {
  export GOVENV_VIRTUALENV_INIT=1
  export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export GOVENV_ACTIVATE_SHELL=1

  GOVENV_SHELL="bash" run govenv-sh-deactivate

  assert_success
  assert_output <<EOS
unset GOVENV_VERSION;
unset GOVENV_ACTIVATE_SHELL;
unset GOVENV_VIRTUAL_ENV;
unset VIRTUAL_ENV;
if [ -n "\${_OLD_VIRTUAL_PATH}" ]; then
  export PATH="\${_OLD_VIRTUAL_PATH}";
  unset _OLD_VIRTUAL_PATH;
fi;
if [ -n "\${_OLD_VIRTUAL_PYTHONHOME}" ]; then
  export PYTHONHOME="\${_OLD_VIRTUAL_PYTHONHOME}";
  unset _OLD_VIRTUAL_PYTHONHOME;
fi;
if [ -n "\${_OLD_VIRTUAL_PS1}" ]; then
  export PS1="\${_OLD_VIRTUAL_PS1}";
  unset _OLD_VIRTUAL_PS1;
fi;
if declare -f deactivate 1>/dev/null 2>&1; then
  unset -f deactivate;
fi;
EOS
}

@test "deactivate virtualenv (with shell activation) (quiet)" {
  export GOVENV_VIRTUALENV_INIT=1
  export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export GOVENV_ACTIVATE_SHELL=1

  GOVENV_SHELL="bash" run govenv-sh-deactivate --quiet

  assert_success
  assert_output <<EOS
unset GOVENV_VERSION;
unset GOVENV_ACTIVATE_SHELL;
unset GOVENV_VIRTUAL_ENV;
unset VIRTUAL_ENV;
if [ -n "\${_OLD_VIRTUAL_PATH}" ]; then
  export PATH="\${_OLD_VIRTUAL_PATH}";
  unset _OLD_VIRTUAL_PATH;
fi;
if [ -n "\${_OLD_VIRTUAL_PYTHONHOME}" ]; then
  export PYTHONHOME="\${_OLD_VIRTUAL_PYTHONHOME}";
  unset _OLD_VIRTUAL_PYTHONHOME;
fi;
if [ -n "\${_OLD_VIRTUAL_PS1}" ]; then
  export PS1="\${_OLD_VIRTUAL_PS1}";
  unset _OLD_VIRTUAL_PS1;
fi;
if declare -f deactivate 1>/dev/null 2>&1; then
  unset -f deactivate;
fi;
EOS
}

@test "deactivate virtualenv which has been activated manually" {
  export GOVENV_VIRTUALENV_INIT=1
  export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export GOVENV_ACTIVATE_SHELL=

  GOVENV_SHELL="bash" run govenv-sh-deactivate

  assert_success
  assert_output <<EOS
unset GOVENV_VIRTUAL_ENV;
unset VIRTUAL_ENV;
if [ -n "\${_OLD_VIRTUAL_PATH}" ]; then
  export PATH="\${_OLD_VIRTUAL_PATH}";
  unset _OLD_VIRTUAL_PATH;
fi;
if [ -n "\${_OLD_VIRTUAL_PYTHONHOME}" ]; then
  export PYTHONHOME="\${_OLD_VIRTUAL_PYTHONHOME}";
  unset _OLD_VIRTUAL_PYTHONHOME;
fi;
if [ -n "\${_OLD_VIRTUAL_PS1}" ]; then
  export PS1="\${_OLD_VIRTUAL_PS1}";
  unset _OLD_VIRTUAL_PS1;
fi;
if declare -f deactivate 1>/dev/null 2>&1; then
  unset -f deactivate;
fi;
EOS
}

@test "deactivate virtualenv (fish)" {
  export GOVENV_VIRTUALENV_INIT=1
  export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export GOVENV_ACTIVATE_SHELL=

  GOVENV_SHELL="fish" run govenv-sh-deactivate

  assert_success
  assert_output <<EOS
set -e GOVENV_VIRTUAL_ENV;
set -e VIRTUAL_ENV;
if [ -n "\$_OLD_VIRTUAL_PATH" ];
  set -gx PATH "\$_OLD_VIRTUAL_PATH";
  set -e _OLD_VIRTUAL_PATH;
end;
if [ -n "\$_OLD_VIRTUAL_PYTHONHOME" ];
  set -gx PYTHONHOME "\$_OLD_VIRTUAL_PYTHONHOME";
  set -e _OLD_VIRTUAL_PYTHONHOME;
end;
if functions -q deactivate;
  functions -e deactivate;
end;
EOS
}

@test "deactivate virtualenv (fish) (quiet)" {
  export GOVENV_VIRTUALENV_INIT=1
  export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export GOVENV_ACTIVATE_SHELL=

  GOVENV_SHELL="fish" run govenv-sh-deactivate --quiet

  assert_success
  assert_output <<EOS
set -e GOVENV_VIRTUAL_ENV;
set -e VIRTUAL_ENV;
if [ -n "\$_OLD_VIRTUAL_PATH" ];
  set -gx PATH "\$_OLD_VIRTUAL_PATH";
  set -e _OLD_VIRTUAL_PATH;
end;
if [ -n "\$_OLD_VIRTUAL_PYTHONHOME" ];
  set -gx PYTHONHOME "\$_OLD_VIRTUAL_PYTHONHOME";
  set -e _OLD_VIRTUAL_PYTHONHOME;
end;
if functions -q deactivate;
  functions -e deactivate;
end;
EOS
}

@test "deactivate virtualenv (fish) (with shell activation)" {
  export GOVENV_VIRTUALENV_INIT=1
  export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export GOVENV_ACTIVATE_SHELL=1

  GOVENV_SHELL="fish" run govenv-sh-deactivate

  assert_success
  assert_output <<EOS
set -e GOVENV_VERSION;
set -e GOVENV_ACTIVATE_SHELL;
set -e GOVENV_VIRTUAL_ENV;
set -e VIRTUAL_ENV;
if [ -n "\$_OLD_VIRTUAL_PATH" ];
  set -gx PATH "\$_OLD_VIRTUAL_PATH";
  set -e _OLD_VIRTUAL_PATH;
end;
if [ -n "\$_OLD_VIRTUAL_PYTHONHOME" ];
  set -gx PYTHONHOME "\$_OLD_VIRTUAL_PYTHONHOME";
  set -e _OLD_VIRTUAL_PYTHONHOME;
end;
if functions -q deactivate;
  functions -e deactivate;
end;
EOS
}

@test "deactivate virtualenv (fish) (with shell activation) (quiet)" {
  export GOVENV_VIRTUALENV_INIT=1
  export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export GOVENV_ACTIVATE_SHELL=1

  GOVENV_SHELL="fish" run govenv-sh-deactivate --quiet

  assert_success
  assert_output <<EOS
set -e GOVENV_VERSION;
set -e GOVENV_ACTIVATE_SHELL;
set -e GOVENV_VIRTUAL_ENV;
set -e VIRTUAL_ENV;
if [ -n "\$_OLD_VIRTUAL_PATH" ];
  set -gx PATH "\$_OLD_VIRTUAL_PATH";
  set -e _OLD_VIRTUAL_PATH;
end;
if [ -n "\$_OLD_VIRTUAL_PYTHONHOME" ];
  set -gx PYTHONHOME "\$_OLD_VIRTUAL_PYTHONHOME";
  set -e _OLD_VIRTUAL_PYTHONHOME;
end;
if functions -q deactivate;
  functions -e deactivate;
end;
EOS
}

@test "deactivate virtualenv which has been activated manually (fish)" {
  export GOVENV_VIRTUALENV_INIT=1
  export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export GOVENV_ACTIVATE_SHELL=

  GOVENV_SHELL="fish" run govenv-sh-deactivate

  assert_success
  assert_output <<EOS
set -e GOVENV_VIRTUAL_ENV;
set -e VIRTUAL_ENV;
if [ -n "\$_OLD_VIRTUAL_PATH" ];
  set -gx PATH "\$_OLD_VIRTUAL_PATH";
  set -e _OLD_VIRTUAL_PATH;
end;
if [ -n "\$_OLD_VIRTUAL_PYTHONHOME" ];
  set -gx PYTHONHOME "\$_OLD_VIRTUAL_PYTHONHOME";
  set -e _OLD_VIRTUAL_PYTHONHOME;
end;
if functions -q deactivate;
  functions -e deactivate;
end;
EOS
}

@test "should fail if deactivate is invoked as a command" {
  run govenv-deactivate

  assert_failure
}
