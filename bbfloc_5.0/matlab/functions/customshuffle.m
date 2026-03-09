function shuffledArray = customshuffle(arr)
    while true
        % Shuffle the array
        shuffledArray = arr(randperm(length(arr)));
        
        % Check if consecutive elements from specific pairs are adjacent
        isValid = true;
        pairs = [1, 2; 3, 4; 5, 6; 7, 8]; % Define the pairs of elements that should not be adjacent
        
        for i = 1:size(pairs, 1)
            % Get the indices of the current pair
            firstIdx = find(shuffledArray == arr(pairs(i, 1)));
            secondIdx = find(shuffledArray == arr(pairs(i, 2)));
            
            % If the indices of the pair are adjacent, it's invalid
            if abs(firstIdx - secondIdx) == 1
                isValid = false;
                break;
            end
        end
        
        % If the shuffle is valid, break the loop
        if isValid
            break;
        end
    end
end
