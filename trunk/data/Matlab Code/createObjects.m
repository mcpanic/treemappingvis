% Build the JavaScript objects representing the tree
function createObjects(element)

ee = element.getElementsByTagName('label')[0]

% element.label = element.getElementsByTagName('label')(0).firstChild.nodeValue;        
% element.url = element.getElementsByTagName('url')(0).firstChild.nodeValue;
%         
% children = element.getElementsByTagName('children')(0).childNodes;
%         
% for (i = 1:children.length) 
%     if (children(i).nodeType ~= 3 & children(i).tagName == 'node') 
%         element.children.push(createObjects(children(i))); % Recurse on children
%     end
% end