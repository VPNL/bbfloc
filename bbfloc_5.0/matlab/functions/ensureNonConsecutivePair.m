% Function to shuffle and ensure no consecutive numbers n and n+1
function shuffledArray = customShuffle(arr)
    while true
        % Shuffle the array
        shuffledArray = arr(randperm(length(arr)));
        
        % Check if consecutive numbers are n and n+1 (or n+1 and n)
        isValid = true;
        for i = 1:length(shuffledArray)-1
            if abs(shuffledArray(i) - shuffledArray(i+1)) == 1
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