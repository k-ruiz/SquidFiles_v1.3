function [L] = convergence_2D_FF(arrays,conv_norm_type)

    [~,~,ns] = size(arrays);
    L = zeros(ns-1,1);

    if conv_norm_type == 2 % (2-norm) Frobenius norm
        for ii = 1:ns-1
            array1 = arrays(end,end,ii);
            array2 = arrays(end,end,ii+1);
            L(ii) =  abs(array2-array1);
        end
        L = L/ns;
    end % End L2-norm IF loop

    if conv_norm_type == inf % (2-norm) Frobenius norm
        for ii = 1:ns-1
            array1 = arrays(1,1,ii);
            array2 = arrays(1,1,ii+1);
            L(ii) = max(abs(array2-array1));
        end
    end % End L2-norm IF loop

end

