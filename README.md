# Fast Two-View Motion Segmentation Using Christoffel Polynomials

**Authors**: Bengisu Ozbay, Octavia Camps, and Mario Sznaier

## Abstract
We address the problem of segmenting moving rigid objects based on two-view image correspondences under a perspective camera model. Existing methods scale poorly with the number of correspondences. This paper proposes a fast segmentation algorithm that scales linearly with the number of correspondences and shows that it offers the best trade-off between error and computational time on benchmark datasets.

## Introduction
Motion segmentation –segmenting distinct moving objects in a sequence of frames– has a wide range of applications in computer vision and robotics. While existing methods for trajectory association and object segmentation are effective, they are often computationally expensive. Our proposed method addresses these issues by using Christoffel polynomials to efficiently segment points one surface at a time.


## Problem Setup


## Methodology
### One at a Time Algebraic Clustering

### Refinements for Two View Motion Segmentation


## Experimental Evaluation
### Datasets
- Adelaide-F
- Hopkins-Clean (H-C) and Hopkins-Outliers (H-O)
- KT3D
- BC and BCD
- Pairwise
### Results and Analysis


## Conclusion
Using Christoffel polynomial to build the support set of algebraic varieties together with a “one-at-a-time” clustering strategy results in a robust and computationally efficient segmentation algorithm. The proposed method has shown accuracy comparable to or better than the state-of-the-art while being at least 10 times faster.


## Supplementary Materials
