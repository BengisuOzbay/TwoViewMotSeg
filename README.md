# Fast Two-View Motion Segmentation Using Christoffel Polynomials

**Authors**: Bengisu Ozbay, Octavia Camps, and Mario Sznaier

## Abstract
We address the problem of segmenting moving rigid objects based on two-view image correspondences under a perspective camera model. Existing methods scale poorly with the number of correspondences. This paper proposes a fast segmentation algorithm that scales linearly with the number of correspondences and shows that it offers the best trade-off between error and computational time on benchmark datasets.

## Introduction
Motion segmentation –segmenting distinct moving objects in a sequence of frames– has a wide range of applications in computer vision and robotics. While existing methods for trajectory association and object segmentation are effective, they are often computationally expensive. Our proposed method addresses these issues by using Christoffel polynomials to efficiently segment points one surface at a time.

## Introduction
Motion segmentation –segmenting distinct moving objects in a sequence of frames– has a wide range of applications in computer vision and robotics. While existing methods for trajectory association and object segmentation are effective, they are often computationally expensive. Our proposed method addresses these issues by using Christoffel polynomials to efficiently segment points one surface at a time.

## Related Work
### Sampling Based Approaches
Most of the sampling based methods build on RANSAC, which searches for consensus between randomly sampled minimal sets to estimate a single model. Extensions of RANSAC have been applied to problems with multiple structures, but they depend on prior knowledge such as matching scores or spatial distance.

### Model Fitting Based Approaches
The T-linkage approach starts with random sampling to generate hypotheses from minimal sample sets and uses a preference function for clustering. Other methods such as RPA use robust M-estimators combined with robust component analysis for model fitting. These methods generally achieve good performance but have high computational complexity.

## Problem Setup
The goal of this paper is to assign correspondences to objects by clustering points lying on quadratic surfaces. Each correspondence between two perspective views of a scene must satisfy the epipolar constraint and lie on the quadratic surface defined by the fundamental matrix of the object.

## Methodology
### One at a Time Algebraic Clustering
Our iterative algorithm uses the Christoffel polynomial to approximate the support of each quadratic surface and segments points one at a time. Reliable inliers are identified and used to refine the polynomial estimate, and the process is repeated until all points are labeled.

### Refinements for Two View Motion Segmentation
We use a restricted Veronese map and estimate the fundamental matrix from reliable points to find additional correspondences. This improves robustness and efficiency in two-view motion segmentation.

## Experimental Evaluation
### Datasets
- **Adelaide-F**: A subset of the Adelaide-RMF dataset for fundamental matrix estimation.
- **Hopkins-Clean (H-C) and Hopkins-Outliers (H-O)**: Subsets of the Hopkins dataset with and without synthetic outliers.
- **KT3D**: A dataset with realistic challenges such as perspective effects and small object movements.
- **BC and BCD**: Image pairs with a large number of correspondences.
- **Pairwise**: A dataset for pairwise matching with noisy SIFT correspondences.

### Results and Analysis
Our method consistently outperforms state-of-the-art algorithms in terms of both accuracy and computational time. Detailed results for each dataset are provided in the paper.

## Conclusion
Using the Christoffel polynomial for algebraic clustering and a one-at-a-time strategy results in a robust and efficient segmentation algorithm. Our method achieves comparable or better accuracy than existing methods while being significantly faster.

## Supplementary Materials
