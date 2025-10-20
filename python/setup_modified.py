import sys
from pathlib import Path
from setuptools import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import os # <-- 新增：导入 os 模块

# Manual setup for Windows. These will take precedence over the automatic
# process below. Make sure the same version of OpenCV is installed in
# Python as the one installed from source.
# 
# Base folder of OpenCV installation. E.g. "D:/opencv"
# 从环境变量 OPENCV_ROOT 获取 OpenCV 安装的根目录 (例如 D:/opencv-manually-built/opencv/build)
opencv_root = os.environ.get("OPENCV_ROOT", "") # <-- 修改：从环境变量获取

# Check if OpenCV is installed
try:
    import cv2
    # cv2.__version__ 是例如 "4.10.0"，替换 "." 得到 "4100"
    version = cv2.__version__.replace(".", "")
except ImportError:
    sys.exit("Required Python OpenCV package not found.")


# Manually installed OpenCV procedure for Windows
if opencv_root:
    # 不再需要 subprocess 来获取 opencv_src_version，直接依赖环境变量。
    # import subprocess # <-- 删除：不再需要

    import shutil

    # OPENCV_ROOT 环境变量被设置为 D:/opencv-manually-built/opencv/build
    # 所以这里的 Path 应该直接在其下寻找 x64/vc17/bin 等

    # 假设 OpenCV 的 Build 目录结构为 {OPENCV_ROOT}/x64/vc17/bin
    opencv_bin = Path(opencv_root) / "x64/vc17/bin" # <-- 修改：移除 "build/" 并明确使用 "vc17"
    
    # 从环境变量 OPENCV_BUILD_VERSION 获取 OpenCV 的构建版本 (例如 "4100")
    opencv_src_version = os.environ.get("OPENCV_BUILD_VERSION", "-1") # <-- 修改：从环境变量获取版本

    if version != opencv_src_version:
        sys.exit(f"Version mismatch: Python OpenCV ({version}) and installed OpenCV ({opencv_src_version} from env)")

    # 包含目录为 {OPENCV_ROOT}/include
    opencv_include = Path(opencv_root) / "include" # <-- 修改：移除 "build/"
    # 库文件目录为 {OPENCV_ROOT}/x64/vc17/lib
    opencv_lib_dirs = Path(opencv_root) / "x64/vc17/lib" # <-- 修改：移除 "build/" 并明确使用 "vc17"
    extra_compile_args = ["/TP"]
    libraries = [f"opencv_world{opencv_src_version}"] # <-- 修改：使用环境变量获取的版本

    # Need to copy opencv_world to installation folder  
    # so Python will successfully find the OpenCV library
    shutil.copy(str(opencv_bin / f"opencv_world{opencv_src_version}.dll"), ".") # <-- 修改：使用环境变量获取的版本


# Attempt to automatically find the associated OpenCV header 
# and library files for the current Python installation.
else:
    import sysconfig

    base = Path(sysconfig.get_config_var("base"))
    extra_compile_args = []

    if sys.platform.startswith("win32"):
        opencv_include = base / "Library/include"
        opencv_lib_dirs = base / "Library/lib"
        extra_compile_args += ["/TP"]
        libraries = [
            f"opencv_core{version}",
            f"opencv_highgui{version}",
            f"opencv_imgproc{version}",
            f"opencv_imgcodecs{version}",
            f"opencv_flann{version}",
        ]

    elif sys.platform.startswith("linux"):
        opencv_include = base / "include/opencv4"
        opencv_lib_dirs = base / "lib"
        libraries = [
            "opencv_core", 
            "opencv_highgui", 
            "opencv_imgproc", 
            "opencv_imgcodecs", 
            "opencv_flann"
        ]

    else:
        sys.exit("System platform build process not yet implemented.")


# Obtain the numpy include directory. This logic works across numpy versions.
import numpy as np
try:
    numpy_include = np.get_include()
except AttributeError:
    numpy_include = np.get_numpy_include()


ext_modules = [
    Extension(
        "pyAAMED",
        [
            "../src/adaptApproximateContours.cpp",
            "../src/adaptApproxPolyDP.cpp",
            "../src/Contours.cpp",
            "../src/EllipseNonMaximumSuppression.cpp",
            "../src/FLED.cpp",
            "../src/FLED_drawAndWriteFunctions.cpp",
            "../src/FLED_Initialization.cpp",
            "../src/FLED_PrivateFunctions.cpp",
            "../src/Group.cpp",
            "../src/LinkMatrix.cpp",
            "../src/Node_FC.cpp",
            "../src/Segmentation.cpp",
            "../src/Validation.cpp",
            "pyAAMED.pyx"
        ],
        include_dirs = [
            str(opencv_include),
            numpy_include,
            "FLED"
        ],
        language = "c++",
        extra_compile_args = extra_compile_args,
        libraries = libraries,
        library_dirs = [str(opencv_lib_dirs)] # 将 opencv_lib_dirs 转换为字符串
    ),
]


class custom_build_ext(build_ext):
    def build_extensions(self):
        build_ext.build_extensions(self)


setup(
    name = "pyaamed",
    ext_modules = ext_modules,
    cmdclass = {"build_ext": custom_build_ext},
)

print("Build done")
