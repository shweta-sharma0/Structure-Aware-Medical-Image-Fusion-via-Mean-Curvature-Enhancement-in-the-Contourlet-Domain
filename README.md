# Structure-Aware-Medical-Image-Fusion-via-Mean-Curvature-Enhancement-in-the-Contourlet-Domain

The fusion method consists of the following steps:

1. Contourlet Decomposition: Images are decomposed into low-frequency (approximation) and high-frequency (detail) components using a multiscale Laplacian-like method.
2. Fusion Strategy:
   - Low-frequency components are fused using a weighted average.
   - The highest-frequency layer (Layer 3) is further enhanced using a mean curvature filter to sharpen anatomical edges.
   - High-frequency components are fused using a max-absolute selection rule.
3. Image Reconstruction: The fused image is reconstructed from the combined low- and high-frequency layers.
4. Output: The final fused image is displayed and saved.

---

 📁 Files Included

- `main.m`: Main script for loading images, performing fusion, displaying results, and saving the output.

 🛠️ Requirements

- MATLAB R2018a or later (tested on R2022b)
- Image Processing Toolbox

Dataset Used
- https://github.com/dawachyophel/medical-fusion/tree/main/MyDataset
- https://www.med.harvard.edu/aanlib/"



