function BPF = mk_BPF(freq, fs, oct)

% Initialize
% octave center as [250, 500, 1000, 2000]
num_freq = length(freq);

%Allocate
BPF = cell(num_freq, 1);

for n = 1:num_freq
    
    fh = freq(n)*(2^(+1/(2*oct)));
    fl = freq(n)*(2^(-1/(2*oct)));
    
    df = fh-fl;
    
    Ntap = 2; %幅
    
    while(1)
        if(df / 8 < fs / Ntap)
            Ntap = 2 * Ntap;
        else
            break;
        end
    end
    
    BPF{n} = fir1(Ntap, 2*[fl,fh]/fs, 'bandpass');
    
end