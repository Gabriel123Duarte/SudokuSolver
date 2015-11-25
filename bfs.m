function [im] = bfs(im, i, j, troca)
    import java.util.LinkedList;
    
    dx = [1 -1 0 0];
    dy = [0 0 -1 1];
    
    q = LinkedList();
    q.add([i j]);
    
    [tamX, tamY] = size(im);
    
    while q.size() > 0
        aux = q.remove();
        
        im(aux(1), aux(2)) = troca;
        for x = 1:4
            if (aux(1) + dx(x)) <= tamX && (aux(1) + dx(x)) >= 1 && (aux(2) + dy(x)) <= tamY && (aux(2) + dy(x)) >= 1
                if im(aux(1) + dx(x), aux(2) + dy(x)) == 1 - troca
                    q.add([aux(1) + dx(x), aux(2) + dy(x)]);
                    im(aux(1) + dx(x), aux(2) + dy(x)) = troca;
                end
            end
        end
            
    end
end