function bits = demodulate ( syms , modType )
nSyms = length ( syms ) ;

 switch modType
 case 'bpsk'
 bits = ( real ( syms ) < 0) ;
 case 'qpsk'
 bits = zeros (1 , 2* nSyms ) ;
 bits (1:2: end ) = ( real ( syms ) < 0) ;
 bits (2:2: end ) = ( imag ( syms ) < 0) ;
 case '16qam'
bits = zeros (1 , 4* nSyms ) ;
bits (1:4: end ) = real ( syms ) < 0;
bits (2:4: end ) = imag ( syms ) < 0;
bits (3:4: end ) = abs( real ( syms ) ) > 2/ sqrt (10) ;
bits (4:4: end ) = abs( imag ( syms ) ) > 2/ sqrt (10) ;
 end
 
 end