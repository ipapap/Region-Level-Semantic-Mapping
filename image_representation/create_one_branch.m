function [tree, currentNodeId, visual_word_id_growing] = create_one_branch(x, currentNodeId, tree, parentID, currentLevel, visual_word_id_growing, numOfImages)


if(size(x,1)>=tree.numOfBranches)
    [idx,C] = kmeans(x, tree.numOfBranches);
    
    for i = 1:tree.numOfBranches
        
        tree.nodes(currentNodeId).parentId = parentID;
        tree.nodes(currentNodeId).descriptor = C(i,:);
        tree.nodes(parentID).childrenIds(i) = currentNodeId;
        
        currentNodeId = currentNodeId + 1;
        
        if(currentLevel < tree.numOfLevels)
            [tree, currentNodeId, visual_word_id_growing] = create_one_branch(x(idx==i,:), currentNodeId, tree, tree.nodes(parentID).childrenIds(i), currentLevel+1, visual_word_id_growing, numOfImages);
        else
            tree.nodes(currentNodeId-1).visual_word_id = visual_word_id_growing;
            visual_word_id_growing = visual_word_id_growing + 1;
            tree.nodes(currentNodeId-1).weight = numOfImages/size(x,1);
         end
        
    end
else
%     tree.nodes(currentNodeId-1).visual_word_id = visual_word_id_growing;
    tree.nodes(parentID).visual_word_id = visual_word_id_growing;
    visual_word_id_growing = visual_word_id_growing + 1;
    tree.nodes(parentID).weight = numOfImages/size(x,1);%log(numOfImages/size(x,1));
end