# 这是一个示例的容错包装（只示意关键部分）。请把它合并到你的原始 setup.py 中适当位置。
import os
import subprocess
import sys

def safe_check_output(cmd, **kwargs):
    # cmd 可为 list 或 string；我们尽量以 list 形式调用
    try:
        print("Executing external command:", cmd)
        out = subprocess.check_output(cmd, stderr=subprocess.STDOUT, **kwargs)
        return out
    except FileNotFoundError:
        # 更友好地报错，提示哪个命令缺失
        exe = cmd[0] if isinstance(cmd, (list, tuple)) else cmd.split()[0]
        print(f"ERROR: External command not found in PATH: {exe}", file=sys.stderr)
        print("Please ensure the command is installed or set OPENCV_ROOT to a valid OpenCV SDK path.", file=sys.stderr)
        raise
    except subprocess.CalledProcessError as e:
        print("Command failed:", e.cmd)
        print("Exit code:", e.returncode)
        print("Output:", e.output.decode(errors='ignore'))
        raise

# 优先使用环境变量 OPENCV_ROOT（由 workflow 写入），fallback 到硬编码路径或自动检测
OPENCV_ROOT = os.environ.get("OPENCV_ROOT") or ""
if not OPENCV_ROOT:
    # 这里可以放你的旧检测逻辑，例如调用某个外部工具来查询路径
    # 但不要直接假定外部程序存在——使用 safe_check_output 包装
    try:
        # 示例：某些 setup.py 可能会调用 opencv_version 或 pkg-config，示例只是演示
        # out = safe_check_output(["pkg-config", "--modversion", "opencv4"])
        # print("pkg-config 返回: ", out)
        pass
    except Exception:
        # 忽略，将稍后报错或提示用户
        pass

# 如果你需要把 OPENCV_ROOT 写进脚本，用 OPENCV_ROOT 变量替换之前的硬编码路径
print("Using OPENCV_ROOT =", OPENCV_ROOT)

# 下面继续你原有的 setup()、Extension(...) 配置逻辑，确保在链接库、include_dirs 等地方使用 OPENCV_ROOT 路径：
# example:
# include_dirs = [ os.path.join(OPENCV_ROOT, 'include'), ... ]
# library_dirs = [ os.path.join(OPENCV_ROOT, 'lib'), ... ]