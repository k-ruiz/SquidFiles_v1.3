function [L] = convergence_2D(arrays,conv_norm_type)

    [~,~,ns] = size(arrays);
    L = zeros(ns-1,1);

    if conv_norm_type == 2 % (2-norm) Frobenius norm
        for ii = 1:ns-1
            array1 = arrays(:,:,ii);
            array2 = arrays(:,:,ii+1);
            [a,b] = size(array1);
            L(ii) = sqrt( (1/(a*b)) * sum(sum((array2-array1).^2)));
        end
        L = L/ns;
    end % End L2-norm IF loop

    if conv_norm_type == inf % (2-norm) Frobenius norm
        for ii = 1:ns-1
            array1 = arrays(:,:,ii);
            array2 = arrays(:,:,ii+1);
            L(ii) = max(max(abs(array2-array1)));
        end
    end % End L2-norm IF loop

end

