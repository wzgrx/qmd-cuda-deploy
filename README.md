---
name: qmd-cuda-deploy
description: One-click deployment script for QMD with CUDA acceleration on WSL2. Handles environment setup, compilation, patching, and verification for RTX 5090/4090 GPUs.
triggers:
  - qmd deploy
  - qmd cuda setup
  - deploy qmd gpu
---

# QMD CUDA Deployment Guide (WSL2 + RTX 5090/4090)

This project provides a complete, automated workflow for deploying **QMD memory engine** with **full CUDA GPU acceleration** on **WSL2**.

## 🎯 Features

- **One-click deployment**: `./deploy.sh` handles everything from environment setup to compilation
- **WSL2-specific fixes**: NVM npm repair, cuBLAS cleanup, VMM crash prevention
- **Latest llama.cpp support**: Automatically pulls and patches the latest master branch
- **Zero manual intervention**: All patches and configurations are applied automatically
- **Verification built-in**: Post-deploy GPU status and embedding tests

## 📋 Prerequisites

| Component | Required | Notes |
|:---|:---|:---|
| **OS** | Windows 11 + WSL2 | Mirrored networking recommended |
| **GPU** | NVIDIA RTX 4090/5090 | 24GB+ VRAM recommended |
| **CUDA** | 13.2 | Must be installed in WSL2 |
| **Node.js** | v24.15.0+ | Managed via NVM |
| **QMD** | Installed globally | `npm i -g @tobilu/qmd` |

## 🚀 Quick Start

```bash
# 1. Clone this repository
git clone https://github.com/wzgrx/qmd-cuda-deploy.git
cd qmd-cuda-deploy

# 2. Run deployment
chmod +x deploy.sh
./deploy.sh
```

The script will:
1. ✅ Check CUDA 13.2 installation
2. ✅ Fix NVM npm symlinks
3. ✅ Clean PATH of Windows references
4. ✅ Remove conflicting cuBLAS 10.2 stubs
5. ✅ Download latest llama.cpp master
6. ✅ Apply WSL2 VMM crash patches
7. ✅ Apply API compatibility patches
8. ✅ Compile with CUDA acceleration
9. ✅ Deploy binaries to QMD
10. ✅ Run verification tests

## 🛠️ Manual Steps (if needed)

### Environment Variables
Add to `~/.bashrc`:
```bash
export CUDA_HOME=/usr/local/cuda-13.2
export LD_LIBRARY_PATH=/usr/lib/wsl/lib:/usr/local/cuda-13.2/lib64:$LD_LIBRARY_PATH
```

### Verify GPU
```bash
qmd status
# Should show: GPU: cuda (offloading: yes)
```

### Test Embedding
```bash
qmd embed -f
# Should complete without OOM errors
```

## 📁 Project Structure

```
├── deploy.sh          # Main deployment script
├── scripts/
│   ├── 01-check-env.sh      # Environment validation
│   ├── 02-fix-nvm-npm.sh    # NVM npm repair
│   ├── 03-clean-path.sh     # PATH cleanup
│   ├── 04-remove-cublas.sh  # cuBLAS stub removal
│   ├── 05-patch-source.sh   # Apply source patches
│   ├── 06-compile.sh        # CUDA compilation
│   └── 07-deploy-test.sh    # Deploy and verify
├── patches/
│   ├── vmm-fix.patch        # VMM crash prevention
│   └── api-compat.patch     # API compatibility patches
└── README.md
```

## 🐛 Troubleshooting

| Error | Cause | Solution |
|:---|:---|:---|
| `UNC paths not supported` | Windows npm hijacking | Run `02-fix-nvm-npm.sh` |
| `cuMemAddressReserve failed` | VMM virtual memory limit | Patch applied automatically |
| `no CUDA-capable device` | Missing WSL driver libs | Set `LD_LIBRARY_PATH` |
| `qmd embed` crashes | Old .node binary loaded | Run `07-deploy-test.sh` |

## 📄 License

MIT
