clear all; clc;

label = 20;
x = 25;
y = 0;
w = 956;
h = 90;

im = imread('MOO.png', 'png');

dom = xmlread('tree_moo.xml');
root = dom.getDocumentElement;

createObjects(root);

% cropImage(im, label, x, y, w, h);