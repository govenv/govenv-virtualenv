#!/usr/bin/env bats

load test_helper

setup() {
  export HOME="${TMP}"
  export GOVENV_ROOT="${TMP}/govenv"
  unset GOVENV_VERSION
  unset GOVENV_ACTIVATE_SHELL
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

@test "activate virtualenv from current version" {
  export GOVENV_VIRTUALENV_INIT=1

  stub govenv-version-name "echo venv"
  stub govenv-virtualenv-prefix "venv : echo \"${GOVENV_ROOT}/versions/venv\""
  stub govenv-prefix "venv : echo \"${GOVENV_ROOT}/versions/venv\""
  stub govenv-sh-deactivate "--force --quiet : echo deactivated"

  GOVENV_SHELL="bash" GOVENV_VERSION="venv" run govenv-sh-activate

  assert_success
  assert_output <<EOS
deactivated
export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv";
export VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv";
govenv-virtualenv: prompt changing will be removed from future release. configure \`export GOVENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(venv) \${PS1}";
EOS

  unstub govenv-version-name
  unstub govenv-virtualenv-prefix
  unstub govenv-prefix
  unstub govenv-sh-deactivate
}

@test "activate virtualenv from current version (quiet)" {
  export GOVENV_VIRTUALENV_INIT=1

  stub govenv-version-name "echo venv"
  stub govenv-virtualenv-prefix "venv : echo \"${GOVENV_ROOT}/versions/venv\""
  stub govenv-prefix "venv : echo \"${GOVENV_ROOT}/versions/venv\""
  stub govenv-sh-deactivate "--force --quiet : echo deactivated"

  GOVENV_SHELL="bash" GOVENV_VERSION="venv" run govenv-sh-activate --quiet

  assert_success
  assert_output <<EOS
deactivated
export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv";
export VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv";
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(venv) \${PS1}";
EOS

  unstub govenv-version-name
  unstub govenv-virtualenv-prefix
  unstub govenv-prefix
  unstub govenv-sh-deactivate
}

@test "activate virtualenv from current version (verbose)" {
  export GOVENV_VIRTUALENV_INIT=1
  export GOVENV_VIRTUALENV_VERBOSE_ACTIVATE=1

  stub govenv-version-name "echo venv"
  stub govenv-virtualenv-prefix "venv : echo \"${GOVENV_ROOT}/versions/venv\""
  stub govenv-prefix "venv : echo \"${GOVENV_ROOT}/versions/venv\""
  stub govenv-sh-deactivate "--force --quiet : echo deactivated"

  GOVENV_SHELL="bash" GOVENV_VERSION="venv" run govenv-sh-activate --verbose

  assert_success
  assert_output <<EOS
deactivated
govenv-virtualenv: activate venv
export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv";
export VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv";
govenv-virtualenv: prompt changing will be removed from future release. configure \`export GOVENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(venv) \${PS1}";
EOS

  unstub govenv-version-name
  unstub govenv-virtualenv-prefix
  unstub govenv-prefix
  unstub govenv-sh-deactivate
}

@test "activate virtualenv from current version (without govenv-virtualenv-init)" {
  export GOVENV_VIRTUALENV_INIT=

  stub govenv-version-name "echo venv"
  stub govenv-virtualenv-prefix "venv : echo \"${GOVENV_ROOT}/versions/venv\""
  stub govenv-prefix "venv : echo \"${GOVENV_ROOT}/versions/venv\""
  stub govenv-sh-deactivate "--force --quiet : echo deactivated"

  GOVENV_SHELL="bash" GOVENV_VERSION="venv" run govenv-sh-activate

  assert_success
  assert_output <<EOS
deactivated
export GOVENV_VERSION="venv";
export GOVENV_ACTIVATE_SHELL=1;
export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv";
export VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv";
govenv-virtualenv: prompt changing will be removed from future release. configure \`export GOVENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(venv) \${PS1}";
EOS

  unstub govenv-version-name
  unstub govenv-virtualenv-prefix
  unstub govenv-prefix
  unstub govenv-sh-deactivate
}

@test "activate virtualenv from current version (fish)" {
  export GOVENV_VIRTUALENV_INIT=1

  stub govenv-version-name "echo venv"
  stub govenv-virtualenv-prefix "venv : echo \"${GOVENV_ROOT}/versions/venv\""
  stub govenv-prefix "venv : echo \"${GOVENV_ROOT}/versions/venv\""
  stub govenv-sh-deactivate "--force --quiet : echo deactivated"

  GOVENV_SHELL="fish" GOVENV_VERSION="venv" run govenv-sh-activate

  assert_success
  assert_output <<EOS
deactivated
set -gx GOVENV_VIRTUAL_ENV "${GOVENV_ROOT}/versions/venv";
set -gx VIRTUAL_ENV "${GOVENV_ROOT}/versions/venv";
govenv-virtualenv: prompt changing not working for fish.
EOS

  unstub govenv-version-name
  unstub govenv-virtualenv-prefix
  unstub govenv-prefix
  unstub govenv-sh-deactivate
}

@test "activate virtualenv from current version (fish) (without govenv-virtualenv-init)" {
  export GOVENV_VIRTUALENV_INIT=

  stub govenv-version-name "echo venv"
  stub govenv-virtualenv-prefix "venv : echo \"${GOVENV_ROOT}/versions/venv\""
  stub govenv-prefix "venv : echo \"${GOVENV_ROOT}/versions/venv\""
  stub govenv-sh-deactivate "--force --quiet : echo deactivated"

  GOVENV_SHELL="fish" GOVENV_VERSION="venv" run govenv-sh-activate

  assert_success
  assert_output <<EOS
deactivated
set -gx GOVENV_VERSION "venv";
set -gx GOVENV_ACTIVATE_SHELL 1;
set -gx GOVENV_VIRTUAL_ENV "${GOVENV_ROOT}/versions/venv";
set -gx VIRTUAL_ENV "${GOVENV_ROOT}/versions/venv";
govenv-virtualenv: prompt changing not working for fish.
EOS

  unstub govenv-version-name
  unstub govenv-virtualenv-prefix
  unstub govenv-prefix
  unstub govenv-sh-deactivate
}

@test "activate virtualenv from command-line argument" {
  export GOVENV_VIRTUALENV_INIT=1

  stub govenv-virtualenv-prefix "venv27 : echo \"${GOVENV_ROOT}/versions/venv27\""
  stub govenv-prefix "venv27 : echo \"${GOVENV_ROOT}/versions/venv27\""
  stub govenv-sh-deactivate "--force --quiet : echo deactivated"

  GOVENV_SHELL="bash" GOVENV_VERSION="venv" run govenv-sh-activate "venv27"

  assert_success
  assert_output <<EOS
deactivated
export GOVENV_VERSION="venv27";
export GOVENV_ACTIVATE_SHELL=1;
export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv27";
export VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv27";
govenv-virtualenv: prompt changing will be removed from future release. configure \`export GOVENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(venv27) \${PS1}";
EOS

  unstub govenv-virtualenv-prefix
  unstub govenv-prefix
  unstub govenv-sh-deactivate
}

@test "activate virtualenv from command-line argument (without govenv-virtualenv-init)" {
  export GOVENV_VIRTUALENV_INIT=

  stub govenv-virtualenv-prefix "venv27 : echo \"${GOVENV_ROOT}/versions/venv27\""
  stub govenv-prefix "venv27 : echo \"${GOVENV_ROOT}/versions/venv27\""
  stub govenv-sh-deactivate "--force --quiet : echo deactivated"

  GOVENV_SHELL="bash" GOVENV_VERSION="venv" run govenv-sh-activate "venv27"

  assert_success
  assert_output <<EOS
deactivated
export GOVENV_VERSION="venv27";
export GOVENV_ACTIVATE_SHELL=1;
export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv27";
export VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv27";
govenv-virtualenv: prompt changing will be removed from future release. configure \`export GOVENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(venv27) \${PS1}";
EOS

  unstub govenv-virtualenv-prefix
  unstub govenv-prefix
  unstub govenv-sh-deactivate
}

@test "activate virtualenv from command-line argument (fish)" {
  export GOVENV_VIRTUALENV_INIT=1

  stub govenv-virtualenv-prefix "venv27 : echo \"${GOVENV_ROOT}/versions/venv27\""
  stub govenv-prefix "venv27 : echo \"${GOVENV_ROOT}/versions/venv27\""
  stub govenv-sh-deactivate "--force --quiet : echo deactivated"

  GOVENV_SHELL="fish" GOVENV_VERSION="venv" run govenv-sh-activate "venv27"

  assert_success
  assert_output <<EOS
deactivated
set -gx GOVENV_VERSION "venv27";
set -gx GOVENV_ACTIVATE_SHELL 1;
set -gx GOVENV_VIRTUAL_ENV "${GOVENV_ROOT}/versions/venv27";
set -gx VIRTUAL_ENV "${GOVENV_ROOT}/versions/venv27";
govenv-virtualenv: prompt changing not working for fish.
EOS

  unstub govenv-virtualenv-prefix
  unstub govenv-prefix
  unstub govenv-sh-deactivate
}

@test "activate virtualenv from command-line argument (fish) (without govenv-virtualenv-init)" {
  export GOVENV_VIRTUALENV_INIT=

  stub govenv-virtualenv-prefix "venv27 : echo \"${GOVENV_ROOT}/versions/venv27\""
  stub govenv-prefix "venv27 : echo \"${GOVENV_ROOT}/versions/venv27\""
  stub govenv-sh-deactivate "--force --quiet : echo deactivated"

  GOVENV_SHELL="fish" GOVENV_VERSION="venv" run govenv-sh-activate "venv27"

  assert_success
  assert_output <<EOS
deactivated
set -gx GOVENV_VERSION "venv27";
set -gx GOVENV_ACTIVATE_SHELL 1;
set -gx GOVENV_VIRTUAL_ENV "${GOVENV_ROOT}/versions/venv27";
set -gx VIRTUAL_ENV "${GOVENV_ROOT}/versions/venv27";
govenv-virtualenv: prompt changing not working for fish.
EOS

  unstub govenv-virtualenv-prefix
  unstub govenv-prefix
  unstub govenv-sh-deactivate
}

@test "unset invokes deactivate" {
  export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv"
  export GOVENV_ACTIVATE_SHELL=

  stub govenv-sh-deactivate " : echo deactivated"

  run govenv-sh-activate --unset

  assert_success
  assert_output <<EOS
deactivated
EOS

  unstub govenv-sh-deactivate
}

@test "should fail if the version is not a virtualenv" {
  stub govenv-virtualenv-prefix "3.3.3 : false"
  stub govenv-version-name " : echo 3.3.3"
  stub govenv-virtualenv-prefix "3.3.3/envs/3.3.3 : false"

  run govenv-sh-activate "3.3.3"

  assert_failure
  assert_output <<EOS
govenv-virtualenv: version \`3.3.3' is not a virtualenv
false
EOS

  unstub govenv-virtualenv-prefix
  unstub govenv-version-name
}

@test "should fail if the version is not a virtualenv (quiet)" {
  stub govenv-virtualenv-prefix "3.3.3 : false"
  stub govenv-version-name " : echo 3.3.3"
  stub govenv-virtualenv-prefix "3.3.3/envs/3.3.3 : false"

  run govenv-sh-activate --quiet "3.3.3"

  assert_failure
  assert_output <<EOS
false
EOS

  unstub govenv-virtualenv-prefix
  unstub govenv-version-name
}

@test "should fail if there are multiple versions" {
  stub govenv-virtualenv-prefix "venv : true"
  stub govenv-virtualenv-prefix "venv27 : true"

  run govenv-sh-activate "venv" "venv27"

  assert_failure
  assert_output <<EOS
govenv-virtualenv: cannot activate multiple versions at once: venv venv27
false
EOS

  unstub govenv-virtualenv-prefix
}

@test "should fail if there are multiple virtualenvs (quiet)" {
  stub govenv-virtualenv-prefix "venv : true"
  stub govenv-virtualenv-prefix "venv27 : true"

  run govenv-sh-activate --quiet "venv" "venv27"

  assert_failure
  assert_output <<EOS
false
EOS

  unstub govenv-virtualenv-prefix
}

@test "should fail if the first version is not a virtualenv" {
  export GOVENV_VIRTUALENV_INIT=1

  stub govenv-virtualenv-prefix "2.7.10 : false"
  stub govenv-version-name " : echo 2.7.10"
  stub govenv-virtualenv-prefix "2.7.10/envs/2.7.10 : false"

  run govenv-sh-activate "2.7.10" "venv27"

  assert_failure
  assert_output <<EOS
govenv-virtualenv: version \`2.7.10' is not a virtualenv
false
EOS

  unstub govenv-virtualenv-prefix
  unstub govenv-version-name
}

@test "activate if the first virtualenv is a virtualenv" {
  export GOVENV_VIRTUALENV_INIT=1

  stub govenv-sh-deactivate "--force --quiet : echo deactivated"
  stub govenv-virtualenv-prefix "venv27 : echo \"${GOVENV_ROOT}/versions/venv27\""
  stub govenv-virtualenv-prefix "2.7.10 : false"
  stub govenv-prefix "venv27 : echo \"${GOVENV_ROOT}/versions/venv27\""

  GOVENV_SHELL="bash" run govenv-sh-activate "venv27" "2.7.10"

  assert_success
  assert_output <<EOS
deactivated
export GOVENV_VERSION="venv27:2.7.10";
export GOVENV_ACTIVATE_SHELL=1;
export GOVENV_VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv27";
export VIRTUAL_ENV="${GOVENV_ROOT}/versions/venv27";
govenv-virtualenv: prompt changing will be removed from future release. configure \`export GOVENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
export _OLD_VIRTUAL_PS1="\${PS1}";
export PS1="(venv27) \${PS1}";
EOS

  unstub govenv-sh-deactivate
  unstub govenv-virtualenv-prefix
  unstub govenv-prefix
}

@test "should fail if activate is invoked as a command" {
  run govenv-activate

  assert_failure
}
