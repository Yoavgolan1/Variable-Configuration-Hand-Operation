function [fitresult, gof] = createFit(Mus, My_Ellipse_Vol_root)
%CREATEFIT(MUS,MY_ELLIPSE_VOL_ROOT)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : Mus
%      Y Output: My_Ellipse_Vol_root
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 30-Aug-2018 16:03:01


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( Mus, My_Ellipse_Vol_root );

% Set up fittype and options.
ft = fittype( 'a*x^b+c', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.196359098141348 0.236999778238469 0.396473077949673];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData );
legend( h, 'My_Ellipse_Vol_root vs. Mus', 'untitled fit 1', 'Location', 'NorthEast' );
% Label axes
xlabel Mus
ylabel My_Ellipse_Vol_root
grid on


