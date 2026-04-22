#pagebreak()

#import "@preview/unify:0.7.1": *
#import "@preview/codedis:0.3.0": code

#let qti(value, unit) = qty(value, unit, per:"/")


= Summary<chapter:summary>

This thesis investigates eddy currents in a magnetic levitation system at high velocities and their influence on the magnetic field. The focus is an EMS system with a homogeneous magnet arrangement used by TUM Hyperloop.

After introducing the theoretical foundations of electromagnetism and eddy currents in EMS systems, we derived several analytical models. In particular, we used the model by S. Yamamura @yamamura1975, which applies an adapted rail and yoke geometry and provides an analytical solution for the induced magnetic field based on Maxwell's equations.

The main part of this thesis is the finite-element simulation of eddy currents using Ansys software.
We first used Ansys Maxwell with a transient solver. After evaluating meshing and motion options, we found that the simplified Yamamura model is also the most suitable choice for simulation from a computational perspective. Its reduced geometric complexity requires fewer mesh elements while still capturing the essential physics.
Nevertheless, the computational cost remained high even for a reduced-size Yamamura model. One representative simulation used a velocity of $qti("100", "m/s")$ and a yoke width of $qty("10", "mm")$, which are characteristic parameters for eddy-current induction in this magnetic system.\
We were particularly interested in the magnetic-field profile along the direction of motion in the air gap, from which magnetic forces can be derived. As expected, we observed a reduction of the magnetic field at the magnet nose, followed by recovery toward the magnet tail. At the tail, the magnetic field was even higher than in the case without eddy currents, indicating that the induced field points in the same direction as the applied field in this region. Over the full magnet length, however, the reduction dominated, leading to a net decrease in lift force.\
We compared the simulation results with those of the analytical Yamamura model. The magnetic-field profiles showed clearly different behavior: the simulation produced a reduction at the nose and an increase at the tail, which corresponds mainly to a vertical shift of the profile, while the analytical Yamamura model produced a horizontal shift in the direction of motion.

Because the computational cost in Ansys Maxwell was very high, we used an unconventional approach with Ansys Mechanical and a steady-state thermal solver. We converted thermal elements into electromagnetic elements so that the thermal solver could solve Maxwell's equations.
This approach has several advantages: the steady-state solver is more efficient than the transient solver when only the steady-state solution at constant velocity is required.
In addition, we could reduce the rail size, which substantially reduced the number of mesh elements and therefore the computational cost while preserving the relevant physics.
To compare both methods, we ran simulations with identical parameters and geometry in Ansys Mechanical and Ansys Maxwell. The results agreed well, validating the thermal-solver approach for this problem and enabling more efficient eddy-current simulations.
We then investigated eddy-current induction as a function of velocity, yoke width, yoke length, and applied magnetic field. For velocity, the magnetic-field profile showed the same qualitative shape at all values, but the amplitudes at the nose and tail increased with velocity. A fit of the braking force showed a square-root dependence on velocity.
For yoke width, we again observed stronger field reduction at the nose and stronger field increase at the tail as width increased. In addition, relaxation of the nose dip toward the tail became slower for larger yoke widths. We attribute this to a larger circulation diameter of the eddy currents, both in the transverse ($y$) direction and along the direction of motion ($x$). The braking-force fit showed a square dependence on yoke width.
For yoke length, we observed no direct influence on the eddy currents except for the increased distance between nose and tail regions. Consequently, the braking force remained essentially unaffected.
For the applied magnetic field, controlled through the coil current, we found that the magnetic field scales proportionally with current. The eddy currents, and therefore both the field reduction at the nose and the increase at the tail, also scaled proportionally with current. As expected, the braking force showed a square dependence on current because it is proportional to the square of the magnetic field.
Finally, we performed a global fit for the velocity and yoke-width dependence of braking force to obtain a comprehensive model.

We also simulated the levitation system with a U-shaped magnet, as used in the TUM Hyperloop design. Compared with the Yamamura model, this geometry uses a wider rail width and therefore requires more mesh elements. However, it also allows the direct evaluation of magnetic lift force, because the yokes are on the same rail side and their fields do not cancel each other as in the Yamamura model.
Comparing the magnetic-field profile of the TUM Hyperloop design with the Yamamura model at the same velocity and yoke width, we observed stronger eddy currents, similar to those in the Yamamura model at larger yoke widths. This is caused by the wider rail width in the TUM Hyperloop design, which allows larger circulation diameters of the eddy currents. We found that a comparable profile in the Yamamura model corresponds to roughly 2.5 times the yoke width.
The braking force of the TUM Hyperloop design was about four times higher than that of the Yamamura model at the same velocity, yoke width, and applied magnetic field. In this geometry, the simulation also provided lift force. As expected, lift force decreased with increasing velocity because the net magnetic field in the air gap was reduced more strongly.

This thesis analyzed fundamental theory and modeling of eddy currents in a homogeneous EMS system. Using finite-element simulations, we identified key dependencies on velocity, yoke width, yoke length, and applied magnetic field.
For practical operation, several effects remain relevant for future work.
For example, a numerical implementation of the rail–frame model could serve as an alternative to the analytical Yamamura approach and improve accuracy.
// For example, as an alternative to the analytical Yamamura model, a numerical implementation of the rail-frame model could improve the accuracy of eddy-current simulation.
Because of the skin effect, magnetic flux in the rail may become strongly compressed and drive the magnetic flux density into the nonlinear region of the B-H curve.
The TUM Hyperloop design currently uses a flat rail profile. A U-shaped rail could support vehicle guidance, but it would also increase the magnetic flux path length and may strengthen eddy currents.
Rail lamination will likely reduce eddy currents because the current paths are constrained to smaller loop areas. This is expected to have a similar effect to reducing yoke width.
Finally, introducing smaller magnets at the nose and tail could reduce the magnetic-field gradient along the direction of motion and thereby lower eddy-current losses.
