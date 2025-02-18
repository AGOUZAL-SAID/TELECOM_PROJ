%%%
%%% Shows the Mandelbrot set within a rectangle in the complex plane.
%%%
%%% Arguments:
%%% * x1: real part of bottom left corner;
%%% * y1: imaginary part of bottom left corner;
%%% * x2, y2: likewise for top right corner.
%%%
%%% Example: mandelbrot_display(-2, -1.25, 0.5, 1.25);
%%%
function mandelbrot_display(x1, y1, x2, y2)
  size_x = 200;
  size_y = 200;

  %%% Create a matrix of complex numbers, element (1,1) is top left corner,
  %%% rows are y (imaginary axis), columns are x (real axis), between
  %%% x1 + 1i * y1 and x2 + 1i * y2.
  C = repmat(linspace(x1,x2,size_x),size_y,1)...
      + 1i * repmat(linspace(y2,y1,size_x),size_y,1).';
      
  %%% Calculate their belonging to the Mandelbrot set.
  M = mandelbrot_calc(C, 50);

  %%% Result is between 0 and 1, with 1 for points in the Mandelbrot set;
  %%% however, it's traditional to show black (color 0), so display 1-M.
  imshow(1-M);

  %%% Alternatively, display as color instead of black-and-white.
  %%% See "help colormap" to get a list of available colormaps.
  %cmap = colormap("hot");
  %imshow((1-M) * length(cmap), cmap);
end

%%% Comments for Emacs editor.
%%% Local Variables:
%%% mode: Octave
%%% coding: utf-8
%%% End:
