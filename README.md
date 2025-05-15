## Legacy Node-gyp Compatibility (Python 2.7)

Some older Node.js native modules require Python 2.7 for installation (e.g., if you see errors about 'rU' mode or Python compatibility during `yarn install` or `npm install`).

To temporarily switch your shell to use Python 2.7 for these legacy installs, use the provided script:

```sh
source macos/baseline/legacy-python2-env.sh
```

This will:
- Set `pyenv shell` to Python 2.7.18
- Set `npm_config_python` to Python 2.7
- Print instructions for returning to your previous Python version

**After running your legacy install, return to your normal environment with:**
```sh
pyenv shell --unset
```
or simply open a new terminal window. 