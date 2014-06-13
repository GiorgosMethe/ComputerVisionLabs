#include <pcl/common/common.h>
#include <pcl/io/pcd_io.h>
#include <pcl/features/normal_3d_omp.h>
#include <pcl/surface/mls.h>
#include <pcl/surface/poisson.h>
#include <pcl/io/vtk_io.h>
#include <iostream>
using namespace pcl;
int
main (int argc, char **argv)
{
    pcl::PointCloud<pcl::PointXYZRGBA>::Ptr cloud_rgb (new pcl::PointCloud<pcl::PointXYZRGBA>);
    pcl::io::loadPCDFile (argv[1], *cloud_rgb);

    PointCloud<PointXYZ>::Ptr cloud (new pcl::PointCloud<pcl::PointXYZ>);

    cloud->resize(cloud_rgb->size());
    for (size_t i = 0; i < cloud_rgb->points.size(); i++)
    {
        cloud->points[i].x = cloud_rgb->points[i].x;
        cloud->points[i].y = cloud_rgb->points[i].y;
        cloud->points[i].z = cloud_rgb->points[i].z;
    }

    MovingLeastSquares<PointXYZ, PointXYZ> mls;

 mls.setInputCloud (cloud);
 mls.setSearchRadius (0.01);
 mls.setPolynomialFit (true);
 mls.setPolynomialOrder (2);
 mls.setUpsamplingMethod (MovingLeastSquares<PointXYZ, PointXYZ>::SAMPLE_LOCAL_PLANE);
 mls.setUpsamplingRadius (0.005);
 mls.setUpsamplingStepSize (0.003);

 PointCloud<PointXYZ>::Ptr cloud_smoothed (new PointCloud<PointXYZ> ());
 mls.process (*cloud_smoothed);
 NormalEstimationOMP<PointXYZ, Normal> ne;
 ne.setNumberOfThreads (8);
 ne.setInputCloud (cloud_smoothed);
 ne.setRadiusSearch (0.01);
 Eigen::Vector4f centroid;
 compute3DCentroid (*cloud_smoothed, centroid);
 ne.setViewPoint (centroid[0], centroid[1], centroid[2]);
 PointCloud<Normal>::Ptr cloud_normals (new PointCloud<Normal> ());
 ne.compute (*cloud_normals);
 for (size_t i = 0; i < cloud_normals->size (); ++i)
 {
 cloud_normals->points[i].normal_x *= -1;
 cloud_normals->points[i].normal_y *= -1;
 cloud_normals->points[i].normal_z *= -1;
 }
 PointCloud<PointNormal>::Ptr cloud_smoothed_normals (new PointCloud<PointNormal> ());
 concatenateFields (*cloud_smoothed, *cloud_normals, *cloud_smoothed_normals);

Poisson<PointNormal> poisson;
 poisson.setDepth (10);
 poisson.setInputCloud 
(cloud_smoothed_normals);
 PolygonMesh mesh;
 poisson.reconstruct (mesh);

 io::saveVTKFile ("result.ply", mesh);

    return 0;
}
