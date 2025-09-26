#pagebreak()

= Theory <chapter:theory>

== Maxwell equations
#label("section: mx_eqn")
The maxwell equations form the basis for the whole electromagnetic
theory. They describe the behavior of electric and magnetic fields and
their interactions to each other. For the vacuum they are given in the
following form:
$ nabla dot.op arrow(E) & = rho / epsilon.alt_0 $
$ nabla dot.op arrow(B) & = 0 $
$ nabla times arrow(E) & = - frac(partial arrow(B), partial t) $
$ nabla times arrow(B) & = mu_0 arrow(J) + mu_0 epsilon.alt_0 frac(partial arrow(E), partial t) $
where $arrow(E)$ is the electric field, $arrow(B)$ is the magnetic flux
density, $rho$ is the charge density, $epsilon.alt_0$ is the
permittivity of free space, and $mu_0$ is the permeability of free
space. In some application stationary approaches can be used to simplify
the equations. This is especially useful when dealing with static
fields. In these cases the time derivatives terms vanish, and the
equations reduce to:
$ nabla dot.op arrow(E) & = rho / epsilon.alt_0 $
$ nabla dot.op arrow(B) & = 0 $
$ nabla times arrow(E) & = 0 $
$ nabla times arrow(B) & = mu_0 arrow(J) $
The Maxwell equations in
matter, also known as the macroscopic Maxwell equations, are given by:
$ nabla dot.op arrow(D) & = rho_f $
$ nabla dot.op arrow(B) & = 0 $
$ nabla times arrow(E) & = - frac(partial arrow(B), partial t) $
$ nabla times arrow(H) & = arrow(J_f) + frac(partial arrow(D), partial t) $
where $arrow(D)$ is the electric displacement field, $arrow(H)$ is the
magnetic field, $rho_f$ is the free charge density and $arrow(J_f)$ is
the free current density. The connection between the magnetic flux
density and the magnetic field is given as:
$ arrow(B) = mu_0 \( arrow(H) + arrow(M) \) $ where $arrow(M)$ is the
magnetization of the material. In a linear regime this can be
approximated as: $ arrow(B) = mu_0 mu_r arrow(H) $ where $mu_r$ is the
relative permeability of the material. \
Similarly, the connection between the electric flux density and the
electric field is given as:
$ arrow(D) = epsilon.alt_0 arrow(E) + arrow(P) $ where $arrow(P)$ is the
polarization of the material. In a linear regime this can be
approximated as: $ arrow(D) = epsilon.alt_0 epsilon.alt_r arrow(E) $
where $epsilon.alt_r$ is the relative permittivity of the material.

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
$ arrow(F)_C = frac(1, 4 pi epsilon.alt_0) frac(Q_1 Q_2, r^2) arrow(r) $
This force can be explained by the electric Field $arrow(E)$ which is
generated from both charges @demtroeder2:
$ arrow(E) = frac(Q, 4 pi epsilon.alt_0 r^2) arrow(r) $ The general
electric force on one charge in an electric field $q$ is given by
@demtroeder2: $ arrow(F)_E = q dot.op arrow(E) $

=== Electric Field and Potential
<electric-field-and-potential>
The electric potential $phi.alt$ is defined as the work done per unit
charge to bring a charge from infinity to a point in the electric field.
It is related to the electric field by the following equation
@demtroeder2: $ arrow(E) = - nabla phi.alt $ It can be calculated using
vector identities and the first Maxwell equation:
$ nabla dot.op arrow(E) = - nabla dot.op \( nabla phi.alt \) = - Delta phi.alt = rho / epsilon.alt_0 $
where $Delta$ is the Laplace operator. The equation
$ Delta phi.alt = - rho / epsilon.alt_0 $ is called the Poisson
equation. \
Since the Poisson equation is linear, we can conclude that the Coulomb
potentials superpose each other, and we can express the total potential
as follows:
$ phi.alt \( arrow(r) \) = - frac(1, 4 pi epsilon.alt_0) sum_(i = 1)^N frac(Q_i, \| arrow(r) - arrow(r)_i \|) $
or with a spatially dependent charge distribution $rho \( arrow(r) \)$:
$ phi.alt \( arrow(r) \) = - frac(1, 4 pi epsilon.alt_0) integral frac(rho \( arrow(r)' \), \| arrow(r) - arrow(r)' \|) d^3 r' . $
So the electric field can be calculated from a charge distribution
$rho \( arrow(r) \)$:
$ arrow(E) \( arrow(r) \) = - nabla phi.alt \( arrow(r) \) = frac(1, 4 pi epsilon.alt_0) integral frac(rho \( arrow(r)' \), \| arrow(r) - arrow(r)' \|^3) \( arrow(r) - arrow(r)' \) d^3 r' . $

=== Lorentz force
<lorentz-force>
Charged particles can not only experience a force when they are in an
electric field but also in a magnetic field $B$ when they are moving.
This Lorentz force is given by the following term @demtroeder2:
$ arrow(F)_L = q dot.op \( arrow(v) times arrow(B) \) $ Together with
the electric force we can write the general Lorentz force as:
$ arrow(F) = q dot.op \( arrow(E) + arrow(v) times arrow(B) \) $

== Magnetic field of an electric current
<magnetic-field-of-an-electric-current>
=== Ampere's law
<amperes-law>
In his experiment 1820, Hans Christian Ørsted discovered that a
current-carrying wire generates a magnetic field @oersted1820. This can
be described by the Ampere's law @demtroeder2
$ integral.cont arrow(B) dot.op d arrow(s) = mu_0 I $ However, this
equation is only helpful for electric cables or coils. For an arbitrary
current density we need to introduce the magnetic vector potential.

=== Magnetic vector potential
<magnetic-vector-potential>
In contrast to the electrostatic case, it is not possible to define a
scalar potential for the magnetic field, since
$integral.cont arrow(B) dot.op d arrow(s) eq.not 0$ in general. But it
is possible to define a vector potential $A$, which satisfies the
condition $nabla dot.op arrow(B) = 0$
$ arrow(B) = nabla times arrow(A) $ The vector potential $A$ is not
absolutely defined, but is scalable with an arbitrary scalar function
$f$, which will result in the same magnetic field:
$ arrow(A)' = arrow(A) + nabla f $ Therefore one needs an additional
condition, for stationary fields it is common to use the coulomb
calibration $nabla dot.op arrow(A) = 0$.

=== Biot-Savart law
<biot-savart-law>
The magnetic vector potential $arrow(A)$ can be calculated by a given
current density - analogous to the Coulomb potential for the electric
field. We start with the fourth Maxwell equation:
$ nabla times arrow(B) = mu_0 arrow(J) $ Using the definition of the
magnetic vector potential $arrow(B) = nabla times arrow(A)$ we can
rewrite this equation as:
$ nabla times \( nabla times arrow(A) \) = mu_0 arrow(J) $ Expanding the
left-hand side using the vector identity
$nabla times \( nabla times arrow(A) \) = nabla \( nabla dot.op arrow(A) \) - nabla^2 arrow(A)$
we get:
$ nabla \( nabla dot.op arrow(A) \) - nabla^2 arrow(A) = mu_0 arrow(J) $
Since we are considering stationary fields, we can assume that
$nabla dot.op arrow(A) = 0$. This simplifies the equation to:
$ - nabla^2 arrow(A) = mu_0 arrow(J) $ This is a Poisson equation for
the magnetic vector potential $arrow(A)$, which can be solved
analogously to the Poisson equation for the electric potential
$phi.alt$. The solution can be expressed in terms of the current density
$arrow(J)$ and the distance $r$ from the source point as:
$ arrow(A) \( arrow(r) \) = frac(mu_0, 4 pi) integral frac(arrow(J) \( arrow(r)' \), \| arrow(r) - arrow(r)' \|) d^3 r' $
where $arrow(r)'$ is the position vector of the source point. \
Now the magnetic vector potential $arrow(A)$ can be used to calculate
the magnetic field $arrow(B)$ using the definition
$arrow(B) = nabla times arrow(A)$. This gives:
$ arrow(B) \( arrow(r) \) = frac(mu_0, 4 pi) integral nabla times frac(arrow(J) \( arrow(r)' \), \| arrow(r) - arrow(r)' \|^3) d^3 r' $
here it must be noted that the differentiation is respect to the
coordinates of the observation point $arrow(r)$ whereas the integration
is respect to the coordinates of the source point $arrow(r)'$. It can be
simplified width the identity
$\| arrow(r) - arrow(r)' \| = sqrt(\( arrow(r) - arrow(r)' \)^2) = sqrt(\( x - x' \)^2 + \( y - y' \)^2 + \( z - z' \)^2)$
to:
$ arrow(B) \( arrow(r) \) = frac(mu_0, 4 pi) integral frac(arrow(J) \( arrow(r)' \) times \( arrow(r) - arrow(r)' \), \| arrow(r) - arrow(r)' \|^3) d^3 r' $

== Time variant fields
<time-variant-fields>
=== Induction Law
<induction-law>
Michael Faraday discovered the induction law, which states that a
changing magnetic field along a conductor induces an electromotive force
$cal(E)$ (emf): $ cal(E) = - frac(d Phi, d t) $ where
$Phi = integral arrow(B) dot.op d arrow(A)$ is the magnetic flux
enclosed by the conductor. \
The minus sign in the induction law indicates that the induced emf
opposes the change in magnetic flux that caused it. This is known as
Lenz's law. \
The electromotive force is also called induced voltage and has units in
volts (V). It is the energy per unit charge which gives rise to an
electric current but is not dependent on the current load and likewise
not dependent on the resistance of the conductor.

=== Eddy Currents
<eddy-currents>
Currents, which are induced in extended conductors, are called eddy
currents. There are dependent on the time derivative of the magnetic
field $frac(d arrow(B), d t)$ as well as the spacial electrical
resistance $R \( x \, y \, z \)$ of the conductor.

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
