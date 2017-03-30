function vy = vely(t)
global phi1;
global phi2;
global ky;
vy = vel(t).*cos(phi1)*sin(abs(phi2))*ky;