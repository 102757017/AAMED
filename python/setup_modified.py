import sys
from pathlib import Path
from setuptools import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import os

# Manual setup for Windows. These will take precedence over the automatic
# process below. Make sure the same version of OpenCV is installed in
# Python as the one installed from source.
# 
# Base folder of OpenCV installation. E.g. "D:/opencv-manually-built/opencv"
opencv_root = os.environ.get("OPENCV_ROOT", "")

# Check if OpenCV is installed
try:
    import cv2
    version = cv2.__version__.replace(".", "")
except ImportError:
    sys.exit("Required Python OpenCV package not found.")


# Manually installed OpenCV procedure for Windows
if opencv_root:
    # 移除 shutil 导入，因为不再需要其 copy 功能
    # import shutil 

    # OPENCV_ROOT 环境变量现在被设置为 D:/opencv-manually-built/opencv
    # 所以需要重新添加 "build/" 路径组件
    opencv_bin = Path(opencv_root) / "build/x64/vc17/bin" # <-- 修正：添加 "build/"
    
    # 从环境变量 OPENCV_BUILD_VERSION 获取 OpenCV 的构建版本 (例如 "4100")
    opencv_src_version = os.environ.get("OPENCV_BUILD_VERSION", "-1")

    if version != opencv_src_version:
        sys.exit(f"Version mismatch: Python OpenCV ({version}) and installed OpenCV ({opencv_src_version} from env)")

    opencv_include = Path(opencv_root) / "build/include" # <-- 修正：添加 "build/"
    opencv_lib_dirs = Path(opencv_root) / "build/x64/vc17/lib" # <-- 修正：添加 "build/"
    extra_compile_args = ["/TP"]
    libraries = [f"opencv_world{opencv_src_version}"]

    # 🎯 关键修正：删除这一行，DLL 复制已由 GitHub Actions 的 PowerShell 步骤处理
    # shutil.copy(str(opencv_bin / f"opencv_world{opencv_src_version}.dll"), ".")


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
