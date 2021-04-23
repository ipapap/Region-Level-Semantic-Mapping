function tree = createTree(x, numOfLevels, numOfBranches, numOfImages) % x             -> total training samples
                                                          % numOfLevels   -> L
                                                          % numOfBranches -> K
                                                          
                                                          
tree.nodes = [];
tree.numOfLevels = numOfLevels;
tree.numOfBranches = numOfBranches;

totalNumOfNodes = (numOfBranches^(numOfLevels+1)-1)/(numOfBranches-1);

for i=1:totalNumOfNodes
    tree.nodes(i).parentId = 0;
    tree.nodes(i).childrenIds(1:numOfBranches) = 0;
    tree.nodes(i).descriptor = zeros(1, size(x,2));
    tree.nodes(i).visual_word_id = 0;
    tree.nodes(i).weight = 0;
end

currentNodeId = 2;
parentNodeId = 1;
currentLevel = 1;
visual_word_id_growing = 1;

[tree, currentNodeId, visual_word_id_growing] = create_one_branch(x, currentNodeId, tree, parentNodeId, currentLevel, visual_word_id_growing, size(x,1));
tree.total_number_of_visual_words = visual_word_id_growing - 1;