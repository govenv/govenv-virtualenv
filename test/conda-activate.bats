#!/usr/bin/env bats

load test_helper

setup() {
  export HOME="${TMP}"
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

@test "activate conda root from current version" {
  export GOVENV_VIRTUALENV_INIT=1

  setup_conda "anaconda-2.3.0"
  stub govenv-version-name "echo anaconda-2.3.0"
  stub govenv-virtualenv-prefix "anaconda-2.3.0 : echo \"${GOVENV_ROOT}/versions/anaconda-2.3.0\""
  stub govenv-prefix "anaconda-2.3.0 : echo \"${GOVENV_ROOT}/versions/anaconda-2.3.0\""
  stub govenv-sh-deactivate "--force --quiet : echo deactivated"

  GOVENV_SHELL="bash" GOVENV_VERSION="anaconda-2.3.0" run govenv-sh-activate

  assert_success
  assert_output <<EOS
deactivated
export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/anaconda-2.3.0";
export VIRTUAL_ENV="${GOVENV_ROOT}/versions/anaconda-2.3.0";
export CONDA_DEFAULT_ENV="root";
govenv-virtualenv: prompt changing will be removed from future release. configure \`export GOVENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(anaconda-2.3.0) \${PS1}";
export CONDA_PREFIX="${TMP}/govenv/versions/anaconda-2.3.0";
EOS

  unstub govenv-version-name
  unstub govenv-virtualenv-prefix
  unstub govenv-prefix
  unstub govenv-sh-deactivate
  teardown_conda "anaconda-2.3.0"
}

@test "activate conda root from current version (fish)" {
  export GOVENV_VIRTUALENV_INIT=1

  setup_conda "anaconda-2.3.0"
  stub govenv-version-name "echo anaconda-2.3.0"
  stub govenv-virtualenv-prefix "anaconda-2.3.0 : echo \"${GOVENV_ROOT}/versions/anaconda-2.3.0\""
  stub govenv-prefix "anaconda-2.3.0 : echo \"${GOVENV_ROOT}/versions/anaconda-2.3.0\""
  stub govenv-sh-deactivate "--force --quiet : echo deactivated"

  GOVENV_SHELL="fish" GOVENV_VERSION="anaconda-2.3.0" run govenv-sh-activate

  assert_success
  assert_output <<EOS
deactivated
set -gx GOVENV_VIRTUAL_ENV "${TMP}/govenv/versions/anaconda-2.3.0";
set -gx VIRTUAL_ENV "${TMP}/govenv/versions/anaconda-2.3.0";
set -gx CONDA_DEFAULT_ENV "root";
govenv-virtualenv: prompt changing not working for fish.
EOS

  unstub govenv-version-name
  unstub govenv-virtualenv-prefix
  unstub govenv-prefix
  unstub govenv-sh-deactivate
  teardown_conda "anaconda-2.3.0"
}

@test "activate conda root from command-line argument" {
  export GOVENV_VIRTUALENV_INIT=1

  setup_conda "anaconda-2.3.0"
  setup_conda "miniconda-3.9.1"
  stub govenv-virtualenv-prefix "miniconda-3.9.1 : echo \"${GOVENV_ROOT}/versions/miniconda-3.9.1\""
  stub govenv-prefix "miniconda-3.9.1 : echo \"${GOVENV_ROOT}/versions/miniconda-3.9.1\""
  stub govenv-sh-deactivate "--force --quiet : echo deactivated"

  GOVENV_SHELL="bash" GOVENV_VERSION="anaconda-2.3.0" run govenv-sh-activate "miniconda-3.9.1"

  assert_success
  assert_output <<EOS
deactivated
export GOVENV_VERSION="miniconda-3.9.1";
export GOVENV_ACTIVATE_SHELL=1;
export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/miniconda-3.9.1";
export VIRTUAL_ENV="${GOVENV_ROOT}/versions/miniconda-3.9.1";
export CONDA_DEFAULT_ENV="root";
govenv-virtualenv: prompt changing will be removed from future release. configure \`export GOVENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(miniconda-3.9.1) \${PS1}";
export CONDA_PREFIX="${TMP}/govenv/versions/miniconda-3.9.1";
EOS

  unstub govenv-virtualenv-prefix
  unstub govenv-prefix
  unstub govenv-sh-deactivate
  teardown_conda "anaconda-2.3.0"
  teardown_conda "miniconda-3.9.1"
}

@test "activate conda env from current version" {
  export GOVENV_VIRTUALENV_INIT=1

  setup_conda "anaconda-2.3.0" "foo"
  stub govenv-version-name "echo anaconda-2.3.0/envs/foo"
  stub govenv-virtualenv-prefix "anaconda-2.3.0/envs/foo : echo \"${GOVENV_ROOT}/versions/anaconda-2.3.0/envs/foo\""
  stub govenv-prefix "anaconda-2.3.0/envs/foo : echo \"${GOVENV_ROOT}/versions/anaconda-2.3.0/envs/foo\""
  stub govenv-sh-deactivate "--force --quiet : echo deactivated"

  GOVENV_SHELL="bash" GOVENV_VERSION="anaconda-2.3.0/envs/foo" run govenv-sh-activate

  assert_success
  assert_output <<EOS
deactivated
export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/anaconda-2.3.0/envs/foo";
export VIRTUAL_ENV="${GOVENV_ROOT}/versions/anaconda-2.3.0/envs/foo";
export CONDA_DEFAULT_ENV="foo";
govenv-virtualenv: prompt changing will be removed from future release. configure \`export GOVENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(anaconda-2.3.0/envs/foo) \${PS1}";
export CONDA_PREFIX="${TMP}/govenv/versions/anaconda-2.3.0/envs/foo";
. "${GOVENV_ROOT}/versions/anaconda-2.3.0/envs/foo/etc/conda/activate.d/activate.sh";
EOS

  unstub govenv-version-name
  unstub govenv-virtualenv-prefix
  unstub govenv-prefix
  unstub govenv-sh-deactivate
  teardown_conda "anaconda-2.3.0" "foo"
}

@test "activate conda env from command-line argument" {
  export GOVENV_VIRTUALENV_INIT=1

  setup_conda "anaconda-2.3.0" "foo"
  setup_conda "miniconda-3.9.1" "bar"
  stub govenv-virtualenv-prefix "miniconda-3.9.1/envs/bar : echo \"${GOVENV_ROOT}/versions/miniconda-3.9.1\""
  stub govenv-prefix "miniconda-3.9.1/envs/bar : echo \"${GOVENV_ROOT}/versions/miniconda-3.9.1/envs/bar\""
  stub govenv-sh-deactivate "--force --quiet : echo deactivated"

  GOVENV_SHELL="bash" GOVENV_VERSION="anaconda-2.3.0/envs/foo" run govenv-sh-activate "miniconda-3.9.1/envs/bar"

  assert_success
  assert_output <<EOS
deactivated
export GOVENV_VERSION="miniconda-3.9.1/envs/bar";
export GOVENV_ACTIVATE_SHELL=1;
export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/miniconda-3.9.1/envs/bar";
export VIRTUAL_ENV="${GOVENV_ROOT}/versions/miniconda-3.9.1/envs/bar";
export CONDA_DEFAULT_ENV="bar";
govenv-virtualenv: prompt changing will be removed from future release. configure \`export GOVENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(miniconda-3.9.1/envs/bar) \${PS1}";
export CONDA_PREFIX="${TMP}/govenv/versions/miniconda-3.9.1/envs/bar";
. "${GOVENV_ROOT}/versions/miniconda-3.9.1/envs/bar/etc/conda/activate.d/activate.sh";
EOS

  unstub govenv-virtualenv-prefix
  unstub govenv-prefix
  unstub govenv-sh-deactivate
  teardown_conda "anaconda-2.3.0" "foo"
  teardown_conda "miniconda-3.9.1" "bar"
}
