from pathlib import Path
import sys

REPO_ROOT = Path(__file__).resolve().parents[1]
INSID3_ROOT = REPO_ROOT / "INSID3"
if str(INSID3_ROOT) not in sys.path:
    sys.path.insert(0, str(INSID3_ROOT))

from models import build_insid3
from utils.visualization import visualize_prediction

assets_dir = INSID3_ROOT / "assets"
ref_image_path = assets_dir / "ref_cat_image.jpg"
ref_mask_path = assets_dir / "ref_cat_mask.png"
target_image_path = assets_dir / "target_cat_image.jpg"
output_path = REPO_ROOT / "labs" / "target_cat_pred.png"

# Build model
model = build_insid3()

# Set reference and target
model.set_reference(str(ref_image_path), str(ref_mask_path))
model.set_target(str(target_image_path))

# Predict
pred_mask = model.segment()

# Save visualization
visualize_prediction(
    ref_image_path,
    ref_mask_path,
    target_image_path,
    pred_mask,
    output_path,
)
