function vx = velx(t)
global phi1;
global phi2;
global kx;
vx = vel(t).*cos(phi1)*cos(phi2)*kx;