#pagebreak()

#import "@preview/unify:0.7.1": num,qty,numrange,qtyrange
#import "@preview/physica:0.9.6": *

// #bibliography("/thesis.yml")

= Theory <chapter:theory>


== Maxwell equations
#label("section: mx_eqn")
The maxwell equations form the basis for the whole electromagnetic
theory. They describe the behavior of electric and magnetic fields and
their interactions to each other. For the vacuum they are given in the
following form:
$ div vb(E) & = rho / epsilon.alt_0 $<maxwell_E1>
$ div vb(B) & = 0 $<maxwell_B1>
$ curl vb(E) & = - pdv(vb(B), t) $<maxwell_E2>
$ curl vb(B) & = mu_0 vb(J) + mu_0 epsilon.alt_0 pdv(vb(E), t) $<maxwell_B2>
where $vb(E)$ is the electric field, $vb(B)$ is the magnetic flux
density, $rho$ is the charge density, $epsilon.alt_0$ is the
permittivity of free space, and $mu_0$ is the permeability of free
space. \
In some application stationary approaches can be used to simplify
the equations. This is especially useful when dealing with static
fields. In these cases the time derivatives terms vanish, and the
equations reduce to:
$ div vb(E) & = rho / epsilon.alt_0 $
$ div vb(B) & = 0 $
$ curl vb(E) & = 0 $<maxwell_E2_static>
$ curl vb(B) & = mu_0 vb(J) $<maxwell_B2_static>
The Maxwell equations in
matter, also known as the macroscopic Maxwell equations, are given by:
$ div vb(D) & = rho_f $<maxwell_D1>
$ div vb(B) & = 0 $
$ curl vb(E) & = - pdv(vb(B), t) $
$ curl vb(H) & = vb(J)_f + pdv(vb(D), t) $<maxwell_H2>
where $vb(D)$ is the electric displacement field, $vb(H)$ is the
magnetic field, $rho_f$ is the free charge density and $vb(J)_f$ is
the free current density. The term $pdv(vb(D), t)$ is called the displacement current and can be neglected for eddy current problems as we will see later @displacement-current.\
The connection between the magnetic flux density and the magnetic field is given as:
$ vb(B) = mu_0 \( vb(H) + vb(M) \) $<material_equation>
where $vb(M)$ is the magnetization of the material. In a linear regime this can be approximated as:
$ vb(B) = mu_0 mu_r vb(H) $
where $mu_r$ is the relative permeability of the material. \
Similarly, the connection between the electric flux density and the
electric field is given as:
$ vb(D) = epsilon.alt_0 vb(E) + vb(P) $ where $vb(P)$ is the
polarization of the material. In a linear regime this can be
approximated as: $ vb(D) = epsilon.alt_0 epsilon.alt_r vb(E) $
where $epsilon.alt_r$ is the relative permittivity of the material.


== Potentials of the electromagnetic field
In this section we will discuss the potentials of the electromagnetic field and their connection with the electric and magnetic fields. This chapter is mainly taken on @brandt1997elektrodynamik.

=== Electrostatic Scalar Potential
<electrostatic-potential>
The electrostatic potential $phi.alt$ is defined as the work done per unit
charge to bring a charge from infinity to a point in the electric field.
It is related to the electric field by the following equation
@demtroeder2: $ vb(E) = - grad phi.alt $ It can be calculated using
vector identities and the first Maxwell equation:
$ div vb(E) = - div ( grad phi.alt ) = - laplacian phi.alt = rho / epsilon.alt_0 $
where $laplacian$ is the Laplace operator. The equation
$ laplacian phi.alt = - rho / epsilon.alt_0 $ is called a Poisson
equation. \
Since the Poisson equation is linear, we can conclude that the Coulomb
potentials superpose each other, and we can express the total potential
as follows:
$ phi.alt \( vb(r) \) = - frac(1, 4 pi epsilon.alt_0) sum_(i = 1)^N frac(Q_i, \| vb(r) - vb(r)_i \|) $
or with a spatially dependent charge distribution $rho \( vb(r) \)$:
$ phi.alt \( vb(r) \) = - frac(1, 4 pi epsilon.alt_0) integral frac(rho \( vb(r)' \), \| vb(r) - vb(r)' \|) dd(r, 3)' . $
So the electric field can be calculated from a charge distribution
$rho \( vb(r) \)$:
$ vb(E) \( vb(r) \) = - grad phi.alt \( vb(r) \) = frac(1, 4 pi epsilon.alt_0) integral frac(rho \( vb(r)' \), \| vb(r) - vb(r)' \|^3) \( vb(r) - vb(r)' \) dd(r, 3)' . $

=== Magnetic Vector Potential
<magnetic-vector-potential>
In contrast to the electrostatic case, it is not possible to define a
scalar potential for the magnetic field, since
$integral.cont vb(B) dot.op dd(vb(s)) eq.not 0$ in general. But it
is possible to define a vector potential $vb(A)$, which satisfies the
condition $div vb(B) = 0$
$ vb(B) = curl vb(A) $<B-potential>
The vector potential $vb(A)$ is not absolutely defined, but is scalable with an arbitrary scalar function $f$, which will result in the same magnetic field:
$ vb(A)' = vb(A) + grad f $ Therefore one needs an additional
condition, for stationary fields it is common to use the coulomb
calibration $div vb(A) = 0$. \
Using this condition and the equation [maxwell_B2_static] as well as the vector identity
$curl ( curl vb(A) ) = grad ( div vb(A) ) - laplacian vb(A)$ one gets again a Poisson equation, now for the vector potential $vb(A)$:
$ laplacian vb(A) = - mu_0 vb(J) $<Poisson-eq_magnetic>

=== Time-Dependent $vb(A)-phi$ Potential
The electrostatic field $vb(E)$ is free from curls, therefore it can be expressed by a scalar Potential as shown in @electrostatic-potential. But the third Maxwell equation @maxwell_E2 shows that time-dependent electrical fields are not free from curls.\
On the other hand, the magnetic field $vb(B)$ is free from sources also in the time-dependent case, why here a time-dependent vector potential can be introduced, analogous to @magnetic-vector-potential.
$ vb(B)(t,vb(r))=curl vb(A)(t,vb(r)) $
This can be inserted into equation @maxwell_E2 and we see that the expression $vb(E)+pdv(vb(A), t)$ is indeed free from curls.
$ curl (vb(E) + pdv(vb(A), t)) = 0 $
Now there can be again a scalar potential $phi(t)$ be introduced, which is now time-dependent.
$ vb(E)(t,vb(r)) + pdv(vb(A), t)(t,vb(r)) = -grad phi(t,vb(r)) $
For a known vector potential $vb(A)$ and scalar potential $phi$, the electric field is given as:
$ vb(E)(t,vb(r)) = -grad phi(t,vb(r)) + pdv(vb(A), t)(t,vb(r)) $

=== The $vb(T)-Omega$ Potential
We introduce another formulation for the electromagnetic Potentials, where we have an electric vector potential $vb(T)$ and a mangetic scalar potential $Omega$.
The magnetic field is splitted into two parts, a rotational part and a nonrotational part $vb(H)_m$ @kuczmann2008finite:
$ vb(H) = vb(T) + vb(H)_m $
This rotational part is the vector potential $vb(T)$ and its curl equal to the electric current:
$ curl vb(T) = vb(J) $
The nonrotational part $vb(H)_m$ can be derived from the magnetic scalar potential $Omega$:
$ vb(H)_m = -grad Omega $
So the magnetic field can be written as:
$ vb(H) = vb(T) - grad Omega $<T-Omega_potential>






#pagebreak()
== Forces on electrons
#label("section: F_on_e")
In this section the Forces on electrons are discussed.

=== Coulomb force
<coulomb-force>
Electric charged particles like electrons and protons repel or attract
each other depending on the sign of their charge. While equal charges
repel each other, opposite charges attract each other. The magnitude of
the force is given by the size of charge $Q$ and their distance $r$ as
given in the Coulomb law @demtroeder2:
$ vb(F)_C = frac(1, 4 pi epsilon.alt_0) frac(Q_1 Q_2, r^2) vb(r) $
This force can be explained by the electric Field $vb(E)$ which is
generated from both charges @demtroeder2:
$ vb(E) = frac(Q, 4 pi epsilon.alt_0 r^2) vb(r) $ The general
electric force on one charge in an electric field $q$ is given by
@demtroeder2: $ vb(F)_E = q dot.op vb(E) $


=== Lorentz force
<lorentz-force>
Charged particles can not only experience a force when they are in an electric field but also in a magnetic field $B$ when they are moving. This Lorentz force is given by the following term @demtroeder2:
$ vb(F)_L = q dot.op \( vb(v) times vb(B) \) $
Together with the electric force we can write the general Lorentz force as:
$ vb(F) = q dot.op \( vb(E) + vb(v) times vb(B) \) $<general_lf>

== Magnetic field of an electric current
<magnetic-field-of-an-electric-current>
=== Ampere's law
<amperes-law>
In his experiment 1820, Hans Christian Ørsted discovered that a
current-carrying wire generates a magnetic field @oersted1820. This can
be described by the Ampere's law @demtroeder2
$ integral.cont vb(B) dot.op dd(vb(s)) = mu_0 I $ However, this
equation is only helpful for electric cables or coils. For an arbitrary
current density we need to introduce the magnetic vector potential.


=== Biot-Savart law
<biot-savart-law>
The magnetic vector potential $vb(A)$ can be calculated by a given
current density - analogous to the Coulomb potential for the electric
field. We start with the fourth Maxwell equation:
$ curl vb(B) = mu_0 vb(J) $
Using the definition of the magnetic vector potential $vb(B) = curl vb(A)$ we can rewrite this equation as:
$ curl \( curl vb(A) \) = mu_0 vb(J) $
Expanding the left-hand side using the vector identity
$ curl \( curl vb(A) \) = grad \( div vb(A) \) - laplacian vb(A) $<vec_identity_double_curl>
we get:
$ grad \( div vb(A) \) - laplacian vb(A) = mu_0 vb(J) $
Since we are considering stationary fields, we can assume that
$div vb(A) = 0$. This simplifies the equation to:
$ - laplacian vb(A) = mu_0 vb(J) $ This is a Poisson equation for
the magnetic vector potential $vb(A)$, which can be solved
analogously to the Poisson equation for the electric potential
$phi.alt$. The solution can be expressed in terms of the current density
$vb(J)$ and the distance $r$ from the source point as:
$ vb(A) \( vb(r) \) = frac(mu_0, 4 pi) integral frac(vb(J) \( vb(r)' \), \| vb(r) - vb(r)' \|) dd(r, 3)' $
where $vb(r)'$ is the position vector of the source point. \
Now the magnetic vector potential $vb(A)$ can be used to calculate
the magnetic field $vb(B)$ using the definition
$vb(B) = curl vb(A)$. This gives:
$ vb(B) \( vb(r) \) = frac(mu_0, 4 pi) integral curl frac(vb(J) \( vb(r)' \), \| vb(r) - vb(r)' \|^3) dd(r, 3)' $
here it must be noted that the differentiation is respect to the
coordinates of the observation point $vb(r)$ whereas the integration
is respect to the coordinates of the source point $vb(r)'$. It can be
simplified width the identity
$\| vb(r) - vb(r)' \| = sqrt(\( vb(r) - vb(r)' \)^2) = sqrt(\( x - x' \)^2 + \( y - y' \)^2 + \( z - z' \)^2)$
to:
$ vb(B) \( vb(r) \) = frac(mu_0, 4 pi) integral frac(vb(J) \( vb(r)' \) times \( vb(r) - vb(r)' \), \| vb(r) - vb(r)' \|^3) dd(r, 3)' $

== Time variant fields
<time-variant-fields>
=== Induction Law
<induction-law>
Michael Faraday discovered the induction law, which states that a changing magnetic field along a conductor induces an electromotive force
$cal(E)$ (emf):
$ cal(E) = integral.cont_C vb(E) dot d vb(l) =  - dv(Phi, t) $
where $Phi = integral_S vb(B) dot.op dd(vb(n))$ is the magnetic flux enclosed by the conductor. \
The minus sign in the induction law indicates that the induced emf opposes the change in magnetic flux that caused it. This is known as Lenz's law. \
The electromotive force is also called induced voltage and has units in volts (V). It is the energy per unit charge which gives rise to an electric current but is not dependent on the current load and likewise not dependent on the resistance of the conductor.


=== Transformation of Fields
Even before the development of the special relativity, it was understood that physical laws should be invariant under Galilean transformations @jackson1998classical. This means that physical phenomena are the same regardless from which perspective they are observed. \
As an example, consider a conductor loop and a magnet moving relative to each other: \
In the magnet frame the magnet is at rest and the conductor is moving towards the magnet. The electromotive force that induces the current in the conductor can be expressed by Faraday's induction law:
$ integral.cont_C vb(E)' dot dd(vb(l)) = - dv(,t) integral_S vb(B) dot dd(vb(n)) $<induction_law>
An important note is that $vb(E)'$ is the electric field in the coordinate system in which $dd(vb(l))$ is at rest. The total time derivative $dv(,t)=pdv(,t)+vb(v)dot nabla$ must be taken into account. Applying Stokes' theorem yields:
$ dv(,t)integral_S vb(B)dot dd(vb(n)) = integral_S pdv(vb(B),t)dot dd(vb(n)) + integral.cont_C (vb(B)times vb(v))dot dd(vb(l)) $
Equation @induction_law can now be written as
$ integral.cont_C [vb(E)'-(vb(v)times vb(B))]dot dd(vb(l)) = - integral_S pdv(vb(B),t)dot dd(vb(n)) $<induction_magnet_frame>
In the conductor frame the conductor is at rest and the magnet is moving towards the conductor.
Applying Faraday's law to the fixed conductor in the frame of the conductor yields:
$ integral.cont_C vb(E) dot dd(vb(l)) = - integral_S pdv(vb(B), t) dd(vb(n)) $<induction_conductor_frame>
Comparing the equations @induction_magnet_frame and @induction_conductor_frame yields:
$ vb(E)' = vb(E) + (vb(v)times vb(B)) $<E_field_transformation>
So when dealing with different frames which have relative motion to each other, one has to be careful when applying Faraday's law. The correct physics is always given by the two basics laws @feynman1963lectures:
$ vb(F)= q (vb(E) + vb(v)times vb(B)) $
$ curl vb(E) = -pdv(vb(B), t) $




#pagebreak()
== Eddy Currents
<eddy-currents>
Currents, which are induced in extended conductors, are called eddy
currents. There are dependent on the time derivative of the magnetic
field $dv(vb(B), t)$ as well as the spacial electrical
resistance $R \( x \, y \, z \)$ of the conductor @demtroeder2.

=== Neglection of the displacement current
<displacement-current>
As stated before the displacement current $pdv(vb(D), t)$ can be neglected for most eddy current cases @kriezis1992eddy @sinha1987electromagnetic @biro1999edge. This can be easily shown by comparing the conduction current with the displacement current:
$ (|pdv(D, t)|)/(|J|) = (omega epsilon E)/(sigma E) = (omega epsilon)/(sigma) $
For small frequencies and high conductivity, this term becomes smaller. As an example, we consider a conductor like iron with a conductivity of $qty("10.3e6", "S/m")$ and a frequency of $qty("1","MHz")$. Since iron is a conductor its electric permittivity is quite slow and we assume just the vaccum permittivity $epsilon_0$, we get $(omega epsilon_0)/(sigma)  approx num("8.6e-10")$ so the displacement current is negligible compared to the conduction current. This assumption is also known as the quasi-static field.

=== The $vb(A)-phi$ Formulation
Combining equation @maxwell_B2_static and @B-potential one gets following equation @kriezis1992eddy:
$ curl (1/mu curl vb(A)) = vb(J) $
or
$ curl (1/mu curl vb(A)) = -sigma (pdv(vb(A),t)+grad phi) $<A-phi_formulation>
where $vb(J)= vb(J)_e + vb(J)_s$ is the sum of the internally generated eddy-current density $vb(J)_e = -sigma pdv(vb(A),t)$ and the externally impressed source current density $vb(J)_s=-sigma grad phi $. Considering a medium with constant permeability and no externally driven current, this equation reduces to
$ laplacian vb(A)= mu sigma pdv(vb(A),t) $.

=== The $vb(T)-Omega$ Formulation
Based on Maxwell's second equation @maxwell_B1 and inserting the equation for the $vb(T)-Omega$ potential @T-Omega_potential one gets the first equation for the $vb(T)-Omega$ formulation @kriezis1992eddy:
$ div mu (vb(T)-grad vb(T)-Omega) = 0 $
Similarly, the second equation for the $vb(T)-Omega$ formulation results from Maxwell's third equation @maxwell_E2:
$ curl (1/sigma curl vb(T)) = - mu (pdv(vb(T), t) - grad pdv(Omega, t)) $


=== The Field Formulation
Applying a curl on equation @A-phi_formulation yields the field formulation @kriezis1992eddy:
$ curl curl B = -mu sigma pdv(vb(B),t) $
The same equation can be obtained for $vb(E), vb(H)$ and $vb(J)$.\
This formulation is inconveient in regions where he permeability changes discontinously.

=== Skin effect
<skin-effect>
The skin effect is a phenomenon which arises when an alternating
magnetic field is applied to a conductor and describes its
self-shielding from the magnetic field @Likharev2022SkinEffect. Since
the induced eddy currents create a magnetic field that opposes the
applied field, the magnetic field gets suppressed when penetrating the
conductor. This effect is more pronounced at higher frequencies as
induced eddy currents increase with frequency. So the skin depth $delta$
decreases with increasing frequency $omega$:
$ delta = sqrt(frac(2, omega mu sigma)) $ where $mu$ is the magnetic
permeability and $sigma$ is the electrical conductivity of the
conductor.


#pagebreak()
== Magnetic Diffusion
This chapter is mainly taken from @woodson1968

=== Magnetic Field Diffusion
To study the magnetic field diffusion we derive a differential equation from the Maxwell equations and Ohm's law.
Ohm's law is given by
$ vb(J)=sigma vb(E) $
Regarding movements we must consider field transformations as shown in @E_field_transformation which gives us
$ vb(J_f)=sigma(vb(E)+vb(v)times vb(B)) $
Inserting in Maxwell's third equation @maxwell_E2 yields:
$ 1/sigma curl vb(J_f) - curl (vb(v)times vb(B)) = -pdv(vb(B),t) $
Using Maxwell's macroscopic fourth equation @maxwell_H2 (neglecting the displacement current) and the material equation @material_equation eliminates $vb(J_f)$:
$ 1/(mu sigma) curl (curl vb(B)) -curl(vb(v)times vb(B)) = -pdv(vb(B),t) $
We use the vector identity @vec_identity_double_curl and @maxwell_B1 to simplify the equation:
$ 1/(mu sigma) laplacian vb(B) + pdv(vb(B),t) = curl(vb(v)times vb(B)) $<magnetic_field_distribution>
This equation describes the distribution of magnetic field in a conductor. The right-hand side of this equation can be interpreted as the rate of change of magnetic field due to the motion of charges. This change is taken up by a flux change due to ohmic dissipation ($laplacian vb(B)$) and time derivative of flux density ($pdv(vb(B),t)$). \
In absence of material motion this reduces to the diffusion equation
$ 1/(mu sigma) laplacian vb(B) = -pdv(vb(B),t) $
This form of equation is often found to describe diffusions, for example in the diffusion of heat in a solid or neutron diffusion.\
A second simplification of the distribution equation @magnetic_field_distribution is to consider motion, but in a steady-state condition:
$ -1/(mu sigma) laplacian vb(B) = curl (vb(v)times vb(B)) $
