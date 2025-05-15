#!/bin/bash
# legacy-python2-env.sh
#
# Launch a shell with Python 2.7 as default and npm_config_python set for legacy node-gyp compatibility.
#
# Usage:
#   source ./legacy-python2-env.sh
#
# This will:
#   - Set pyenv shell to 2.7.18
#   - Set npm_config_python to Python 2.7
#   - Print instructions for returning to normal (exit the shell or run 'pyenv shell --unset')

if ! pyenv versions | grep -q "2.7.18"; then
  echo "[!] Python 2.7.18 is not installed via pyenv. Installing..."
  pyenv install 2.7.18
fi

export PREV_PYENV_SHELL=$(pyenv version-name)
pyenv shell 2.7.18
export npm_config_python="$(pyenv which python)"
echo "[legacy-python2-env] Python 2.7.18 is now active for this shell."
echo "[legacy-python2-env] npm_config_python set to: $npm_config_python"
echo "[legacy-python2-env] Run your legacy 'yarn install' or 'npm install' now."
echo "[legacy-python2-env] To return to your previous Python version, run:"
echo "    pyenv shell $PREV_PYENV_SHELL" 