function  [x_out] = cordic_old(x_in,theta)
    x_out = x_in;
    if theta > 3*pi*2^12
        theta = theta - pi*2^14;
    elseif theta > pi*2^13
        theta = theta - 3*pi*2^12;
        x_out = x_in*exp(1i*pi/2);
    elseif theta > pi*2^12
        theta = theta - pi*2^12;
        x_out = x_in*exp(-1i*pi/2);
    end
    
    if theta*2^-13 < -7/8 
        x_out = real(x_out) - 2*imag(x_out) + 1i*(imag(x_out) + 2*real(x_out));
        theta = 4*(theta + 2^14);
        K=(1+(-2)^2)^(-0.5);
    elseif theta*2^-13 < -1/2
        x_out = real(x_out) - imag(x_out) + 1i*(imag(x_out) + real(x_out));
        theta = 4*(theta + 2^13);
        K=(1+(-1)^2)^(-0.5);
    elseif theta*2^-13 < 3/8
        x_out = real(x_out)  + 1i*(imag(x_out));
        theta = 4*(theta);
        K=1;
    elseif theta*2^-13 < 5/8
        x_out = real(x_out) + imag(x_out) + 1i*(imag(x_out) - real(x_out));
        theta = 4*(theta - 2^13);
        K=(1+1^2)^(-0.5);
    else
        x_out = real(x_out) + 2*imag(x_out) + 1i*(imag(x_out) - 2*real(x_out));
        theta = 4*(theta - 2^14);
        K=(1+2^2)^(-0.5);
    end

    for k = 1:7 
        if theta*2^-13 < -3/2 
            x_out = real(x_out) - 2*imag(x_out)*4^(-k) + 1i*(imag(x_out) + 2*real(x_out)*4^(-k));
            theta = 4*(theta + 2^14);
            K=K*(1+(4^(-2*k))*(-2)^2)^(-0.5);
        elseif theta*2^-13 < -1/2
            x_out = real(x_out) - imag(x_out)*4^(-k) + 1i*(imag(x_out) + real(x_out)*4^(-k));
            theta = 4*(theta + 2^13);
            K=K*(1+(4^(-2*k))*(-1)^2)^(-0.5);
        elseif theta*2^-13 < 1/2
            x_out = real(x_out)  + 1i*(imag(x_out));
            theta = 4*(theta);
            K=K*(1+(4^(-2*k))*(0)^2)^(-0.5);
        elseif theta*2^-13 < 3/2
            x_out = real(x_out) + imag(x_out)*4^(-k) + 1i*(imag(x_out) - real(x_out)*4^(-k));
            theta = 4*(theta - 2^13);
            K=K*(1+(4^(-2*k))*(1)^2)^(-0.5);
        else
            x_out = real(x_out) + 2*imag(x_out)*4^(-k) + 1i*(imag(x_out) - 2*real(x_out)*4^(-k));
            theta = 4*(theta - 2^14);
            K=K*(1+(4^(-2*k))*(2)^2)^(-0.5);
        end
    end

    x_out = x_out * K;
end