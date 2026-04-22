#import "@preview/codedis:0.3.0": code
#import "@preview/physica:0.9.6": *
// -- Supplementary Material --


// #let code_yam_pyaedt = read("../code/yamamura01.py")

// #code(code_yam_pyaedt, line-numbers: true)

-- Sinha Model --

P. K. Sinha described in his book @sinha1987 a similar model to describe the eddy currents induced by a moving magnetic field along a conducting rail. \
In this approach equation @eq:current_density is also used but instead of the static third Maxwell equation as in the Yamamura model, the dynamic one @maxwell_E2 is used. Sinha uses also the macroscopic Maxwell equations @maxwell_H2 (without the displacment current).
Combining these results in the following differential equation:
$ frac(1, mu sigma)laplacian H = pdv(H, t) + curl (v times H) $
which becomes for an electromagnetic suspension system with a geometry as shown in @fig:yamamura_simplified :
$ frac(1, mu_0 sigma) laplacian B(x,y,z,t) approx frac(2a, 2z) (pdv(B(x,y,z,t), t)) $
where $z$ is the airgap as $g$ in the Yamamura model.
Following assumptions are made for analytical convenience:
- uniform flux density across the heigth of the airgap: $pdv(B, z) = pdv(B^2, z, 2) =0$
- the magnet moves only in the x direction with constant velocity $v$:\ $v=dv(x, t)$, $dv(y, t)=dv(z, t)=0$
- the flux density $B$ is split into two components, the induced flux $B_i$ due to the eddy currents and the excited flux $B_e$ of the magnet current, which is constant $B_0$ over the length of the magnet and $0$ elsewhere.
These relationships combined results in the following differential equation for the airgap:
$
pdv(B_i, x, 2) + pdv(B_i, y, 2) - k pdv(B_i, x) \
= - B_0 (pdv(Delta(x), x)-pdv(Delta(x-l), x))dot(f(y+overline(p))-f(y-overline(p))) + k B_0 (Delta(x)-Delta(x-l)) dot (f(y+overline(p))-f(y-overline(p)))
$
where $k=mu_0 sigma overline(p)v/z$, $Delta(x)$ the appropriate impulse function and $f(x)$ a step function.
This is exact the same differential equation as in the Yamamura model @eq:wave_equation_induced. Therefore this approach is not further discussed, as the same solving methods can be applied.
