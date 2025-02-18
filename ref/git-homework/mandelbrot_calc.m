%%%
%%% Returns "distance" (in iterations) from the Mandelbrot set.
%%%
%%% Arguments:
%%% * C (scalar or matrix): values in the complex plane to evaluate;
%%% * n_iter (positive integer): number of iterations in the calculation.
%%%
%%% Return value: matrix of same size as C, each element's value
%%% (between 0 and 1) represents whether the corresponding element of C
%%% belongs to the Mandelbrot set.
%%% * if 1, then it does
%%% * else it is the number of iterations after which the calculation
%%%   exceeds distance 2 from the origin.
%%%

function M = mandelbrot_calc(C, n_iter)
  n_iter = ceil(n_iter); % Ensure n_iter is int; should check that it's >0.
  [ny,nx] = size(C);
  M = ones(size(C));
  for yy = 1:ny
    for xx = 1:nx
      z =  C(yy,xx);

      %%% Optimizations: if z is within the main cardioid centered at ¼,
      %%% or the disc centered at -1 of radius ¼, we already know it's
      %%% part of the set; so skip this point (M already initialized
      %%% with 1 above).
      %if (abs(z - 0.25) <= 0.5*(1 - cos(angle(z - 0.25)))) ...
      %   || (abs(z + 1) <= 0.25)
      %   continue
      %end

      %% Otherwise, just iterate.
      nn = 1;
      while (abs(z) <= 2) && (nn < n_iter)
        nn = nn + 1;
        z = z^2 + C(yy,xx);
      end

      %%% At this point, either abs(z) <= 2 and we consider C(yy,xx)
      %%% to be in the Mandelbrot set, so we do nothing (M already
      %%% initialized with 1 above); otherwise nn is between 1 and n_iter,
      %%% we must return between 0 (included) and 1 (excluded).
      if (abs(z) > 2)
	      M(yy,xx) = (nn - 1) / n_iter;
      end
    end
  end
end

%%% Comments for Emacs editor.
%%% Local Variables:
%%% mode: Octave
%%% coding: utf-8
%%% End:
