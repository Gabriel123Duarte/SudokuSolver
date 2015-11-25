function [status, S] = backtrack(S)

    [r, c, encontrou] = sudokuEncontrarCelula(S);
    if  encontrou == false
        status = true;
        return        
    end
    
    for num = 1:9
        if sudokuCaminho(S, r, c, num)
            S(r, c) = num;
            
            [status, S] = backtrack(S);
            if status == true
                return
            end
            
            S(r, c) = 0;
        end
    end
    status = false;
end