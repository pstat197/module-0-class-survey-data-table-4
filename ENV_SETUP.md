Environment setup for this notebook

1. Create a virtual environment in the project root (macOS / zsh):

```bash
python3 -m venv .venv
source .venv/bin/activate
```

2. Upgrade pip and install requirements:

```bash
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

3. Register the venv as a Jupyter kernel (so VS Code can select it):

```bash
python -m ipykernel install --user --name=module0_env --display-name "module0_env"
```

4. In VS Code: use "Python: Select Interpreter" to pick `.venv` or the `module0_env` kernel in the notebook kernel selector.

5. If you see the psutil import/ABI error on macOS with Apple Silicon, rebuild psutil from source using:

```bash
python -m pip uninstall -y psutil
python -m pip install --upgrade --force-reinstall --no-binary :all: psutil
```

Notes
- This repo already includes `requirements.txt` listing `pandas`, `jupyter`, `psutil`, and `ipykernel`.
- If you prefer conda, create a conda env and `conda install -c conda-forge pandas jupyter psutil ipykernel`.
