# INSID3 install wrapper

This repository wraps the upstream `INSID3` project and adds convenience scripts for local setup, running inference, and small reproducible labs.

## Repository layout

- `INSID3/`: upstream project code.
- `labs/`: local example scripts.
- `install.sh`: creates `INSID3/.venv`, installs dependencies, and optionally downloads weights.
- `start.sh`, `stop.sh`, `restart.sh`, `log.sh`: process helpers for `INSID3/inference.py`.

## Quick start

From repository root:

```bash
./install.sh
uv run labs/01-minimal-usage.py
```

If you prefer using the `INSID3` virtual environment directly:

```bash
INSID3/.venv/bin/python labs/01-minimal-usage.py
```

## Local DINOv3 weights (required)

This setup expects local checkpoints in `INSID3/pretrain/` and does not fall back to remote downloads.

Required files:

- `INSID3/pretrain/dinov3_vits16_pretrain_lvd1689m-08c60483.pth`
- `INSID3/pretrain/dinov3_vitb16_pretrain_lvd1689m-73cec8be.pth`
- `INSID3/pretrain/dinov3_vitl16_pretrain_lvd1689m-8aa4cbdd.pth`

## Minimal lab script

`labs/01-minimal-usage.py`:

- imports `models`/`utils` from `INSID3/` by updating `sys.path`.
- uses sample assets from `INSID3/assets/`.
- writes output to `labs/target_cat_pred.png`.

Run:

```bash
uv run labs/01-minimal-usage.py
```

## Inference process helpers

Start default inference job:

```bash
./start.sh
```

Follow logs:

```bash
./log.sh --follow
```

Stop:

```bash
./stop.sh
```