function v = vel(t)
global vmax;
global a;
global tmax;
v = a.*t.*(t<=0.2*tmax) + vmax.*(t>0.2*tmax & t<=0.8*tmax) + (vmax - a.*(t - 0.8*tmax)).*(t>=0.8*tmax);