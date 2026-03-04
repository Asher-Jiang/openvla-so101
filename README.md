# openvla-so101

End-to-end workspace for imitation learning on the [SO-101](https://huggingface.co/docs/lerobot/en/so101) robot arm using [LeRobot](https://github.com/huggingface/lerobot) and [Pi0-FAST](https://huggingface.co/docs/lerobot/en/pi0fast).

## Setup

```bash
git clone --recursive https://github.com/Asher-Jiang/openvla-so101.git
cd openvla-so101
chmod +x setup.sh && ./setup.sh
source venv/bin/activate
```

`setup.sh` auto-detects your OS and installs the right dependencies:
- **macOS** — LeRobot + Feetech motor SDK + Pi0-FAST (`[feetech,pi]`)
- **Linux** — LeRobot + Pi0-FAST (`[pi]`), verifies CUDA availability

**Prerequisites:** Python 3.10+, git.

## Components

- **`so-101/`** — SO-101 robot control: motor setup, calibration, teleoperation, and dataset recording. Contains LeRobot as a nested submodule. ([repo](https://github.com/Asher-Jiang/so-101))

- **`Umi_Lerobot_Retargeting/`** — Converts [UMI](https://umi-gripper.github.io/) Zarr datasets to LeRobot v3 format with FPS resampling, inverse kinematics retargeting, and SO-101 replay support. ([repo](https://github.com/rebnoob/Umi_Lerobot_Retargeting))

## Workflow

1. **Record** (Mac) — Teleoperate the SO-101 to collect demonstration episodes with camera data via `lerobot-record`
2. **Train** (Linux/CUDA) — Fine-tune `pi0fast_base` on your dataset via `lerobot-train --policy.type=pi0_fast`
3. **Infer** (Mac) — Deploy the trained policy on the SO-101 via `lerobot-record --policy.path=...`

See the [Pi0-FAST docs](https://huggingface.co/docs/lerobot/en/pi0fast) and [imitation learning guide](https://huggingface.co/docs/lerobot/en/il_robots) for detailed usage.
