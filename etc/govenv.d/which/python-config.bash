# some of libraries require `python-config` in PATH to build native extensions.
# as a workaround, this hook will try to find the executable from the source
# version of the virtualenv.
# https://github.com/yyuu/govenv/issues/397

if [ ! -x "${GOVENV_COMMAND_PATH}" ] && [[ "${GOVENV_COMMAND_PATH##*/}" == "python"*"-config" ]]; then
  OLDIFS="${IFS}"
  IFS=:
  version="$(govenv-version-name)"
  IFS="${OLDIFS}"
  if [ -f "${GOVENV_ROOT}/versions/${version}/bin/activate" ]; then
    if [ -f "${GOVENV_ROOT}/versions/${version}/bin/conda" ]; then
      : # do nothing for conda's environments
    else
      if [ -f "${GOVENV_ROOT}/versions/${version}/bin/pyvenv.cfg" ]; then
        # venv
        virtualenv_binpath="$(cut -b 1-1024 "${GOVENV_ROOT}/versions/${version}/pyvenv.cfg" | sed -n '/^ *home *= */s///p' || true)"
        virtualenv_prefix="${virtualenv_binpath%/bin}"
      else
        # virtualenv
        if [ -d "${GOVENV_ROOT}/versions/${version}/Lib" ]; then
          # jython
          virtualenv_libpath="${GOVENV_ROOT}/versions/${version}/Lib"
        else
          if [ -d "${GOVENV_ROOT}/versions/${version}/lib-python" ]; then
            # pypy
            virtualenv_libpath="${GOVENV_ROOT}/versions/${version}/lib-python"
          else
            virtualenv_libpath="${GOVENV_ROOT}/versions/${version}/lib"
          fi
        fi
        virtualenv_orig_prefix="$(find "${virtualenv_libpath}/" -maxdepth 2 -type f -and -name "orig-prefix.txt" 2>/dev/null | head -1)"
        if [ -f "${virtualenv_orig_prefix}" ]; then
          virtualenv_prefix="$(cat "${virtualenv_orig_prefix}" 2>/dev/null || true)"
        fi
      fi
      virtualenv_command_path="${virtualenv_prefix}/bin/${GOVENV_COMMAND_PATH##*/}"
      if [ -x "${virtualenv_command_path}" ]; then
        GOVENV_COMMAND_PATH="${virtualenv_command_path}"
      fi
    fi
  fi
fi
