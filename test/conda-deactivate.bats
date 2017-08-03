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

@test "deactivate conda root" {
  export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/anaconda-2.3.0"
  export VIRTUAL_ENV="${GOVENV_ROOT}/versions/anaconda-2.3.0"
  export GOVENV_ACTIVATE_SHELL=
  export CONDA_DEFAULT_ENV="root"

  setup_conda "anaconda-2.3.0"

  GOVENV_SHELL="bash" run govenv-sh-deactivate

  assert_success
  assert_output <<EOS
unset CONDA_PREFIX
unset GOVENV_VIRTUAL_ENV;
unset VIRTUAL_ENV;
unset CONDA_DEFAULT_ENV;
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

  teardown_conda "anaconda-2.3.0"
}

@test "deactivate conda root (fish)" {
  export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/anaconda-2.3.0"
  export VIRTUAL_ENV="${GOVENV_ROOT}/versions/anaconda-2.3.0"
  export GOVENV_ACTIVATE_SHELL=
  export CONDA_DEFAULT_ENV="root"

  setup_conda "anaconda-2.3.0"

  GOVENV_SHELL="fish" run govenv-sh-deactivate

  assert_success
  assert_output <<EOS
set -e GOVENV_VIRTUAL_ENV;
set -e VIRTUAL_ENV;
set -e CONDA_DEFAULT_ENV;
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

  teardown_conda "anaconda-2.3.0"
}

@test "deactivate conda env" {
  export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/anaconda-2.3.0/envs/foo"
  export VIRTUAL_ENV="${GOVENV_ROOT}/versions/anaconda-2.3.0/envs/foo"
  export GOVENV_ACTIVATE_SHELL=
  export CONDA_DEFAULT_ENV="foo"

  setup_conda "anaconda-2.3.0" "foo"

  GOVENV_SHELL="bash" run govenv-sh-deactivate

  assert_success
  assert_output <<EOS
. "${GOVENV_ROOT}/versions/anaconda-2.3.0/envs/foo/etc/conda/deactivate.d/deactivate.sh";
unset CONDA_PREFIX
unset GOVENV_VIRTUAL_ENV;
unset VIRTUAL_ENV;
unset CONDA_DEFAULT_ENV;
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

  teardown_conda "anaconda-2.3.0" "foo"
}
