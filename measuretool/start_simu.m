clc;clear;close all;


import java.awt.Robot;
import java.awt.event.*;

global robot
robot = java.awt.Robot;

t = timer;
t.StartDelay = 1;%��ʱ1�뿪ʼ
t.ExecutionMode = 'fixedRate';%����ѭ��ִ��
t.Period = 0.5;%ѭ�����2��
t.TasksToExecute = 10000;%ѭ������9��
t.TimerFcn = @simulationKeybord;

start(t)%��ʼִ��