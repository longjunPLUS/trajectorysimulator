function [x, y, z] = RTlv2ecef(x, y ,z, x0, y0, z0, M)
%#codegen
%LV2ECEF Convert local vertical to geocentric (ECEF) coordinates
%
%   [X, Y, Z] = LV2ECEF(XL, YL, ZL, PHI0, LAMBDA0, H0, ELLIPSOID) converts
%   point locations specified by the coordinate arrays XL, YL, and ZL
%   relative to the local vertical system with its origin at geodetic
%   latitude PHI0, longitude LAMBDA0, and ellipsoidal height H0.  XL, YL,
%   and ZL may be arrays of any shape, as long as they are all the same
%   size.  PHI0, LAMBDA0, and H0 must be scalars.  ELLIPSOID is a row
%   vector with the form [semimajor axis, eccentricity].  XL, YL, ZL, and
%   H0 must have the same length units as the semimajor axis.  PHI0 and
%   LAMBDA must be in radians.  The coordinates X, Y, and Z are in the
%   geocentric system, with the same units as the semimajor axis.
%
%   For a definition of the local vertical system, also known as
%   east-north-up (ENU), see the help for ECEF2LV.  For a definition of the
%   geocentric system, also known as earth-centered, earth-fixed, see the
%   help for GEODETIC2ECEF.
%
%   See also ECEF2GEODETIC, ECEF2LV, ELEVATION, GEODETIC2ECEF.

% Copyright 2005-2009 The MathWorks, Inc.
% $Revision: 1.1.6.3 $  $Date: 2009/04/15 23:34:47 $

% Reference
%   ---------
% Paul R. Wolf and Bon A. Dewitt, "Elements of Photogrammetry with
% Applications in GIS," 3rd Ed., McGraw-Hill, 2000 (Appendix F-4).

% Construct a work array, P, to hold the offset vectors from the local
% vertical origin to the various point locations defined by x, y, z.
% Initially, each column of P is a 3-vector defined with respect to the
% local vertical system.
n = numel(x);
P = zeros(3,n);
P(1,:) = reshape(x, [1 n]);
P(2,:) = reshape(y, [1 n]);
P(3,:) = reshape(z, [1 n]);

% Transform each column of P into an offset vector in the geocentric
% system, overwriting P itself to save storage.  (Note that M is
% orthogonal, so M' is its inverse.)
P = M' * P;

% Extract and reshape a coordinate array for each axis, overwriting x, y,
% and z to save storage.  And convert the offsets wrt the local vertical
% origin to offsets wrt the center of the earth, that is, geocentric
% Cartesian coordinates.
inputSize = size(x);
x = reshape(P(1,:),inputSize) + x0;
y = reshape(P(2,:),inputSize) + y0;
z = reshape(P(3,:),inputSize) + z0;
