clc; clear all; close all;

% PARSEXML Convert XML file to a MATLAB structure.
filename = 'tree_hybrid.xml';
im = imread('hybrid_copy.png', 'png');

try
   tree = xmlread(filename);
catch
   error('Failed to read XML file %s.',filename);
end

% Recurse over child nodes. This could run into problems 
% with very deeply nested trees.
try
   theStruct = parseChildNodes(tree);
catch
   error('Unable to parse XML file %s.',filename);
end

traverseTree(theStruct, im, 0);