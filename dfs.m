function [im] = dfs(im, i, j)
    dx = [1 -1 0 0];
    dy = [0 0 -1 1];
    im(i, j) = 1;
    for x = 1:4
        if (i + dx(x)) <= size(im, 1) && (i + dx(x)) >= 1 && (j + dy(x)) <= size(im, 2) && (j + dy(x)) >= 1
            if im(i + dx(x), j + dy(x)) == 0
                im(i, j) = 1;
                im = dfs(im, i + dx(x), j + dy(x));
            end
        end
    end
end