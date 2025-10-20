import os
import sys
sys.path.append(r"E:\python\AAMED\python")
os.add_dll_directory(r"E:\python\AAMED\python\dll") # 如果遇到DLL加载问题，可以解除注释这行

from pyAAMED import pyAAMED
import cv2


imgC = cv2.imread('contour.jpg')

imgG = cv2.cvtColor(imgC, cv2.COLOR_BGR2GRAY)

aamed = pyAAMED(600, 600)

aamed.setParameters(3.1415926/3, 3.4,0.77)
res = aamed.run_AAMED(imgG)
print(res)

# 调用 drawAAMED 后，imgG 图像上已经绘制了检测到的椭圆
aamed.drawAAMED(imgG)

cv2.imshow('Detected Ellipses', imgG)

cv2.waitKey(0) # 0 表示无限等待，直到用户按下一个键
cv2.destroyAllWindows() # 按键后关闭所有OpenCV窗口
