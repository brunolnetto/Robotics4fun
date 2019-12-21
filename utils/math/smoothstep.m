function val = smoothstep(t, T, y_begin, y_end, degree)
    x = t/T;
            
    switch(degree)
        case 0
            if((t >= 0)&&(x < 1))
                y = x;
                val = y_begin + (y_end - y_begin)*y;
            elseif(x>=1)
                val = y_end;
            else
                val = 0;
            end
        
        case 1
            if((t >= 0)&&(x < 1))
                y = -2*x^3 + 3*x^2;
                val = y_begin + (y_end - y_begin)*y;
            elseif(x>=1)
                val = y_end;
            else
                val = 0;
            end
        
        case 2
            if((t >= 0)&&(x < 1))
                y = 6*x^5 - 15*x^4 + 10*x^3;
                val = y_begin + (y_end - y_begin)*y;
            elseif(x>=1)
                val = y_end;
            else
                val = 0;
            end
            
        case 3
            if((t >= 0)&&(x < 1))
                y = -20*x^7 + 70*x^6 - 84*x^5 + 35*x^4;
                val = y_begin + (y_end - y_begin)*y;
            elseif(x>=1)
                val = y_end;
            else
                val = 0;
            end
            
        case 4
            if((t >= 0)&&(x < 1))
                y = 70*x^9 - 315*x^8 + 540*x^7 - 420*x^6 + 126*x^5;
                val = y_begin + (y_end - y_begin)*y;
            elseif(x>=1)
                val = y_end;
            else
                val = 0;
            end
            
        case 5
            if((t >= 0)&&(x < 1))
                y = -252*x^11 + 1386*x^10 - 3080*x^9 + 3465*x^8 - 1980*x^7 + 462*x^6;
                val = y_begin + (y_end - y_begin)*y;
            elseif(x>=1)
                val = y_end;
            else
                val = 0;
            end

        case 6
            if((t >= 0)&&(x < 1))
                y = 924*x^13 + - 6006*x^12 + 16380*x^11 - 24024*x^10 + 20020*x^9 - 9009*x^8 + 1716*x^7;
                val = y_begin + (y_end - y_begin)*y;
            elseif(x>=1)
                val = y_end;
            else
                val = 0;
            end
            
        otherwise
            error('Degree MUST be between 1 and 6 inclusive!')

    end
end