function traverseTree(node, im, depth)

label = node.Children(1, 1).Children.Data
url = node.Children(1, 2).Children.Data

y = node.Children(1, 3).Attributes(1, 4).Value
x = node.Children(1, 3).Attributes(1, 3).Value
w = node.Children(1, 3).Attributes(1, 2).Value
h = node.Children(1, 3).Attributes(1, 1).Value

cropImage(im, label, str2num(x), str2num(y), str2num(w), str2num(h));

% traverse children
children = node.Children(1, 4).Children;

numChild = size(children, 2);
depth = depth + 1;

for i = 1:numChild
    traverseTree(children(1, i), im, depth);
end