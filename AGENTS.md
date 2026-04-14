# AGENTS

Guidance for coding agents working in this repository.

## Scope

- This repository is a wrapper around the upstream `INSID3` code in `INSID3/`.
- Root-level scripts (`install.sh`, `start.sh`, `stop.sh`, `restart.sh`, `log.sh`) are operational helpers.
- `labs/` contains local reproducible examples.

## Python import/path conventions

- Lab scripts run from repo root and must work without manual `PYTHONPATH` exports.
- When importing from `INSID3/models` or `INSID3/utils`, add `INSID3` to `sys.path` in the script.
- For APIs in `INSID3/models/insid3.py`, pass file paths as `str` (not `pathlib.Path`) to:
  - `model.set_reference(...)`
  - `model.set_target(...)`

## Weights policy

- Use local DINOv3 checkpoints from `INSID3/pretrain/`.
- Do not reintroduce remote fallback if local-only loading is already configured.
- If local weights are missing, fail with a clear actionable error message.

Expected checkpoint filenames:

- `dinov3_vits16_pretrain_lvd1689m-08c60483.pth`
- `dinov3_vitb16_pretrain_lvd1689m-73cec8be.pth`
- `dinov3_vitl16_pretrain_lvd1689m-8aa4cbdd.pth`

## Asset paths for examples

- Prefer absolute/repo-resolved paths over cwd-relative strings like `assets/...`.
- For sample cat demo assets, use `INSID3/assets/`.
- Save generated artifacts from labs into `labs/` unless the user asks otherwise.

## Documentation expectations

- Keep root `README.md` focused on this wrapper repo usage.
- Refer deeper model and research details to `INSID3/README.md`.
- When behavior changes (path resolution, weights loading, scripts), update docs in the same task.
