function photo_table = table_photo(features,tree)

photo_table = zeros(1,tree.total_number_of_visual_words);
totalNumOfFeatures = size(features,1);

for i=1:totalNumOfFeatures
    has_node=1;
    CurrentFeature=features(i,:);
    NodeId=tree.nodes(1);
    
    while has_node>0
        
        t=NodeId.childrenIds;
        
        for j=1:length(t)
            nodeId=t(j);
            NodesChildren(j).nodeId=nodeId;
            NodesChildren(j).descriptors=tree.nodes(nodeId).descriptor;
            NodesChildren(j).distance= (norm(CurrentFeature-NodesChildren(j).descriptors))^2; %since kmeans uses square euclidian distance
        end
        my_min=NodesChildren(1).distance;
        pos_min=1;
        
        for k=1:length(t)
            if my_min>NodesChildren(k).distance
                my_min=NodesChildren(k).distance;
                pos_min=k;
            end
        end
        
        nodeId= NodesChildren(pos_min).nodeId;
        
        if tree.nodes(nodeId).visual_word_id >0
            if(tree.nodes(nodeId).weight == 0)
                photo_table(tree.nodes(nodeId).visual_word_id)=photo_table(tree.nodes(nodeId).visual_word_id)+1;
            else
                photo_table(tree.nodes(nodeId).visual_word_id)=photo_table(tree.nodes(nodeId).visual_word_id)+tree.nodes(nodeId).weight;
            end
            has_node=-1;
        else
            NodeId=tree.nodes(nodeId);
        end
    end
end

photo_table = photo_table / totalNumOfFeatures;
