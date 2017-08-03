resolve_link() {
  $(type -p greadlink readlink | head -1) "$1"
}

if [ -n "${DEFINITION}" ]; then
  if [[ "${DEFINITION}" != "${DEFINITION%/envs/*}" ]]; then
    # Uninstall virtualenv by long name
    exec govenv-virtualenv-delete ${FORCE+-f} "${DEFINITION}"
    exit 128
  else
    VERSION_NAME="${VERSION_NAME:-${DEFINITION##*/}}"
    PREFIX="${PREFIX:-${GOVENV_ROOT}/versions/${VERSION_NAME}}"
    if [ -L "${PREFIX}" ]; then
      REAL_PREFIX="$(resolve_link "${PREFIX}" 2>/dev/null || true)"
      REAL_DEFINITION="${REAL_PREFIX#${GOVENV_ROOT}/versions/}"
      if [[ "${REAL_DEFINITION}" != "${REAL_DEFINITION%/envs/*}" ]]; then
        # Uninstall virtualenv by short name
        exec govenv-virtualenv-delete ${FORCE+-f} "${REAL_DEFINITION}"
        exit 128
      fi
    else
      # Uninstall all virtualenvs inside `envs` directory too
      shopt -s nullglob
      for virtualenv in "${PREFIX}/envs/"*; do
        govenv-virtualenv-delete ${FORCE+-f} "${DEFINITION}/envs/${virtualenv##*/}"
      done
      shopt -u nullglob
    fi
  fi
fi
