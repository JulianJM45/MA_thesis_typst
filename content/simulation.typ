#pagebreak()

#import "@preview/physica:0.9.6": *
#import "@preview/unify:0.7.1": *
#import "@preview/codedis:0.3.0": code

#let qti(value, unit) = qty(value, unit, per:"/")

= Simulation<chapter:simulation>
The simulations for this thesis are conducted using two different software packages: Ansys Maxwell 2025 R2 (Ansys Inc., USA) and Ansys Mechanical 2025 R2 (Ansys Inc., USA).

== Ansys Maxwell
Since Ansys Maxwell is designed for electromagnetic simulations, it is the most suitable choice for this problem. In the following sections, we discuss the steps required to set up the simulation and the available options in Ansys Maxwell for each step.

=== Solver Type
There are several solver types available in Maxwell, such as _Magnetostatic_, _Electrostatic_, and _Eddy Current_. The only solver relevant to our use case is the _Transient_, since it includes motion. \
For transient simulations, Maxwell offers two formulations: the $vb(T)-Omega$ formulation and the $vb(A)-Phi$ formulation. However, motion is only supported with the $vb(T)-Omega$ formulation. Therefore, the $vb(A)-Phi$ formulation is not relevant for this study.\
The $vb(T)-Omega$ formulation is also the default option for the _Transient_ solver, where the order of the magnetic scalar potential $Omega$ is 2 and the order of the electric vector potential $vb(T)$ is 1 @ansys_3D_transient_solver.
For motion problems, Maxwell uses a fixed coordinate system for Maxwell's equations in both the moving and the stationary parts of the model. This eliminates the explicit motion term, so there is no $vb(v) times vb(B)$ term in the current-density equation. Instead, in the stationary frame, the magnetic field changes over time, so Maxwell's third equation @maxwell_E2 can be applied. A combination of Maxwell's third and fourth equations @maxwell_E2 and @maxwell_H2, as well as Ohm's law @ohms_law results in the following differential equation:
$ curl 1/sigma curl vb(H) + pdv(vb(B),t) = 0 $
Together with Maxwell's second equation @maxwell_B1 this set of two equations yields a complete physical description of the problem.
=== Meshing
There are different meshing methods in Ansys that can be applied to a solid. First, Ansys automatically creates an initial mesh, which is then refined by the user in selected regions. \
For the initial mesh, the available methods are @ansys_maxwell_initialmeshsettings:
- Auto (default): automatically selects the mesher, mostly TAU
- TAU: well suited for curved surfaces
- (advanced) TAU Flex Meshing: may reduce meshing time and provides a mesh even for complex geometries
- Classic: uses the Bowyer algorithm. Well suited for geometries with many thin surfaces
- PhiPlus: efficient meshes for designs with layout components
In this thesis, the Auto method is used for the initial meshing. \
In a second step, the mesh is refined in the regions of interest. There are also different methods available for mesh refinement:
- length-based mesh inside an object: applies a mesh inside the whole object with a density specified by the _maximum_length_ parameter
- length-based mesh on object face: applies a mesh on the surface of an object that becomes coarser with distance from the surface. Its density is specified by the _maximum_length_ parameter
- skin depth-based mesh on object face: applies a mesh on the surface of an object which is well suited for skin effects like eddy currents. The density on the surface is specified by _triangulation_max_length_, whereas the depth into the object is specified by _skin_depth_ and the number of layers by _layers_number_.
Maxwell also automatically adapts the mesh in the vicinity of finely meshed regions.



=== Motion
<section:Motion>
Maxwell 3D's _Transient_ solution type offers the option to add motion to an object. This is done by defining a motion band, i.e., a box that encloses the moving object. It is important to note that only one object is allowed inside the motion band. If the object consists of several parts, e.g., a yoke and coil that should move together, these must be wrapped inside an inner band, which then moves inside the motion band.\
Unfortunately, there is a limitation regarding the mesh of the moving band: in contrast to other objects, which can have different mesh densities (e.g. a dense mesh only at one surface), Ansys always applies the highest mesh density of the motion band to the entire band as a length-based mesh inside an object. In other words, if we have only a small region of interest, such as the air gap between magnet and rail where a high-density mesh is required, this high-density mesh is not only applied locally but to the entire moving band. This increases computational costs significantly.\
There are essentially two options for implementing the motion: either move the magnet (yoke and coil) under the rail, or keep the magnet stationary and move the rail. The latter requires a longer moving band in the x-direction (direction of motion), but it can be made significantly smaller in the z-direction because eddy currents occur mainly near the surface, which allows us to model a very thin rail. With a moving rail, the volume of the motion band is significantly smaller, which reduces computation time and is therefore chosen in this study.\
Another option is to build Yamamura's alternative model as shown in  @fig:yamamura_simplified. This allows an even smaller moving band volume since the rail is considerably smaller in the y-direction.



=== Yamamura Model on Ansys Maxwell
#figure(
 image("../figures/simulation/yamamura_y10.png", width: 100%),
 caption: [Depiction of the Yamamura model recreated in Ansys Maxwell.]
)<yamamura_recreated>
As discussed in @section:Motion, the computational cost for the Yamamura model is significantly lower than that of the conventional model, since the rail and thus the moving band can have considerably smaller volumes. This is why the model is recreated in Ansys Maxwell as shown in @yamamura_recreated.
The dimensions of the yoke and the rail are given in $unit("mm")$ in @table:yam_v100_mx.
#figure(
  grid(columns: 2,
  column-gutter: 1em,
  row-gutter: 0.5em,
  [
  #table(
  columns: (auto, auto, auto),
  align: horizon,
  table.header([*Component*], [*Label*], [*Size*]),
  table.cell(rowspan: 2)[*yoke*],
  [L], [135],
  [2a], [10],
  // [yoke_z], [x],
  table.cell(rowspan: 2)[*rail*],
  [rail_x], [245],
  // [2a], [10],
  [2d], [1],
  table.cell(rowspan: 1)[*air gap*],
  [g], [1],
  )],
  [#image("../figures/models/yamamura_simplified.svg", width: 50%)],
  [], []),
  caption:[Geometry of the yoke and the rail in the Yamamura model. The dimensions are given in $unit("mm")$. The labels are the same as in the analytical model in @yamamura-model. Additionally, we introduce the length of the rail _rail_x_, which is infinite in the analytical model but finite in the simulation. The length of the rail is chosen to be long enough to ensure that the eddy currents are stable and do not reach the end of the rail during the simulation time.]
)<table:yam_v100_mx>
\
*Simulation preparation*\
There are several steps to prepare the simulation:
1. Create the geometry of the different components, such as the rail, yoke, coil, and air gap.
2. Assign current to the coils and enable eddy effects for the rail.
3. Assign motion to the rail.
4. Create a setup that defines the simulation parameters.
5. Run the simulation.

In a first simulation, we create the geometry in the dimensions described above and assign a velocity of $qti("100000", "mm/s")$ which corresponds to $qti("100", "m/s")$.
Since the mesh density is about $qti("1", "mm")$ and the velocity is $qti("100", "m/s")$, a time step of $qti("1e-5", "s")$ is chosen.
Previous tests have shown that after around 20--30 time steps, a steady state is reached and the eddy currents become stable. To increase confidence in this result, we chose 90 time steps in this run.\
#figure(
 image("../figures/simulation/eddy_currents_long.png", width: 100%),
 caption: [Depiction of the eddy currents in the Yamamura model at a speed of $qti("100", "m/s")$. The rail is moving from left to right (Top view).]
)<eddy_currents_long>
In @eddy_currents_long we can observe the eddy currents in the rail. They are mainly concentrated at the nose and tail of the magnet. In our frame, electrons move in the positive x-direction and the magnetic field points into the plane, so they are deflected inside the magnet region toward the negative y-direction. Outside the magnet region, the electrons move back toward the positive y-edge of the rail due to electric fields induced by charge separation. This leads to a closed current loop, which is clockwise at the nose and counterclockwise at the tail of the magnet.\
#figure(
 image("../figures/simulation/yam_long_force_x.svg", width: 100%),
 caption: [Braking force of the Yamamura model at speed of $qti("100", "m/s")$ over time, showing the approach to steady-state.]
)<yam_long_force_x>
The braking force over time is shown in @yam_long_force_x. Since this is a transient simulation, the force is not constant but evolves over time until it reaches equilibrium. We observe that after approximately $qty("500", "us")$ (50 time steps), the force becomes stable, confirming that steady state is reached within 90 time steps. The braking force is around $qty("400", "mN")$ and has negative values because it acts opposite to the direction of motion.\
If we insert the geometry parameters of the simulation into the Yamamura model, it yields a braking force of around $qty("3.83", "N")$, which is one order of magnitude larger than the value obtained from the simulation.

Since in the Yamamura geometry the yoke surfaces embrace the rail on both sides, the magnetic forces on the rail (or the magnet) in z-direction, which correspond to the lift force, cancel each other out. Therefore, it is not meaningful to analyze the lift force in this model. To study the lift force, we consider the conventional model in the following sections.

#figure(
 image("../figures/simulation/B_profile_yam_mx_v100.svg", width: 100%),
 caption: [Magnetic field profile of the Yamamura model at speed of $qti("0", "m/s")$ (at $t=0$) and $qti("100", "m/s")$ (at $t=qti("0","s")$).]
)<B_profile_yam_long>
In @B_profile_yam_long, the magnetic field profile in the air gap is shown for zero speed and for a velocity of $qti("100", "m/s")$. It can be observed that at the nose of the magnet the magnetic field is reduced due to the induced field opposing the applied field, whereas at the tail of the magnet the magnetic field is increased due to the induced field acting in the same direction as the applied field. Different regions can be identified, each showing characteristic behavior of the magnetic field. In the nose region, the strongest reduction occurs, starting at $6.3 %$ (at $x=qty("-6.7","cm")$) and decreasing to about $3.1%$ (at $x=qty("-4.5","cm")$). In the central region, the magnetic field gradually returns to the undisturbed value, which is reached at approximately $x=qty("3","cm")$. In the tail region, the magnetic field increases and reaches its maximum at around $x=qty("6.75","cm")$ corresponding to the end of the magnet. Here, the magnetic field rises up to $5.8%$ compared to the zero speed case.

To obtain a clearer understanding of the field redistribution, the difference between the magnetic field at $qti("100", "m/s")$ and the magnetic field at zero speed is plotted in @deltaB_profile_yam_mx_y10.
#figure(
 image("../figures/simulation/deltaB_profile_yam_mx.svg", width: 100%),
 caption: [Change in magnetic field profile of the Yamamura model at speed of $qti("100", "m/s")$.]
)<deltaB_profile_yam_mx_y10>
#figure(
 grid(columns:2, column-gutter: 1em, row-gutter: 0.5em,
 [#image("../figures/simulation/B_profile_yam_mx_v100_small.svg", width: 100%)],
 [#image("../figures/simulation/Yam_analytical_y10_small.svg", width: 100%)],
 [(a)],[(b)],
 ),
 caption: [Comparison between the magnetic field profile of the Yamamura model simulated with Ansys Maxwell (a) and Ansys Mechanical (b) at speed of $qti("100", "m/s")$.]
)<B_profile_yam_mx_analy_comparison>
It can be observed that the net change in the magnetic field, i.e. the sum of the local field reduction and increase along the x-direction, is negative. This results in an overall reduction of the magnetic field in the air gap and therefore in a reduction of the lift force of the system. Since the magnetic force is no longer evenly distributed along the x-axis, this also leads to a tilting of the magnet (and, in a real system, of the vehicle), which is disadvantageous for the stability of the system.

The magnetic field profile at $qti("100", "m/s")$ can also be compared to the results of the analytical Yamamura model, as shown in @B_profile_yam_mx_analy_comparison. The profiles exhibit different behavior: while the simulation shows a localized reduction of the magnetic field at the nose and an increase at the tail, the analytical Yamamura model predicts a spatial shift of the entire magnetic field profile in the x-direction toward the tail.



== Simulation with Ansys Mechanical
The simulation using Ansys Maxwell is computationally inefficient for several reasons. The main limitation is that, for our problem, Maxwell only allows a transient setup, even though we are interested solely in the steady-state solution. This results, on the one hand, in a more complex solution procedure and, on the other hand, in the need for a larger rail geometry. Due to restrictions in Ansys Maxwell, the fine mesh must be applied throughout the entire rail volume, leading to an inefficient use of computational resources, as discussed in @section:Motion. Furthermore, Ansys Maxwell is not well optimized for parallel computing, so all calculations are effectively executed on a single thread. As a consequence, computation times are very long, reaching up to approximately three weeks for a model with the geometry described in @table:yam_v100_mx. Therefore, we investigate an alternative approach using Ansys Mechanical with an unconventional solver type for this problem, namely a steady-state thermal solver.

=== Description of the setup
The entire setup is implemented within Ansys Workbench, where the geometry is created in Ansys Discovery and then imported into Ansys Mechanical.
==== Geometry
#let geo_code = read("../code/yamamura_geo.py")
The geometry is constructed in Ansys Discovery using PyAnsys Geometry. The model consists of five bodies: the rail, the yoke, the coil, a (finely meshed) air gap region, and a surrounding region box enclosing the entire model.
The air gap body does not represent the full air gap between the rail and the yoke but only a narrow strip within it, along which we evaluate the magnetic field with high spatial resolution.
Care must be taken to avoid overlaps among the bodies. This is ensured, for example, by subtracting the individual bodies from the surrounding region.
#code(geo_code, lines:(182,182), line-numbers:false)
\
For a successful meshing, all bodies must be combined using a shared topology.
#code(geo_code, lines:(198,198), line-numbers:false)

==== Material Data
The model consists of three materials selected from the _General_Materials_ library in Ansys: Air, Copper Alloy and Gray Cast Iron. The corresponding material properties are listed in the following @table:materials.

#figure(
table(
 columns: (auto, auto, auto),
 align: horizon,

 table.header([*Material*], [*Isotropic Resistivity ($unit("O m")$)*], [*Isotropic Relative Permeability*]),
 [Air], [-], [1],
 [Copper Alloy], [$num("1.694e-8") $], [1],
 [Gray Cast Iron], [$num("9.6e-8")$], [10000]
),
caption:[Material properties of the different materials used in the Ansys Mechanical simulation. The values for the isotropic relative permeability are dimensionless.]
)<table:materials>
Since a steady-state thermal solver is employed, an isotropic thermal conductivity must be assigned to each material. Here we can choose an arbitrary value for _Isotropic Thermal Conductivity_, since this value is absolutely irrelevant for the solution, but it is needed for the Ansys solver to start the simulation.
==== Meshing
All components, except for the surrounding region box, are assigned a finer mesh. The coil and the yoke are assigned a _Body Mesh Sizing_ of $qty("1.5", "mm")$. In addition, the yoke is meshed using the _Patch Conforming Method_, which generates a mesh of _Tetrahedrons_ instead of the default _Hexahedrons_, used for the other bodies.
The air gap region is assigned a _Body Mesh Sizing_ of $qty("0.1", "mm")$ in order to ensure a high spatial resolution of the magnetic field.
For the rail, three mesh sizing methods are applied along the edges. Along the x-edge we assign an _Edge Mesh Sizing_ of $qty("0.4", "mm")$, along the y-edge we assign an _Edge Mesh Sizing_ of $qty("0.5", "mm")$, and along the z-edge we assign an _Edge Mesh Sizing_ of $qty("0.1", "mm")$, with the latter two using a bias that makes the mesh finer on the surfaces and coarser in the middle of the rail.

==== Additional preparations
To apply a current to the coil, we need to define an _Element Orientation_ with the y-coordinate along the current flow direction.\
It is often convenient, and necessary for the _APDL_ script, to define a _Named Selection_ for bodies, surfaces, and edges where we want to assign a velocity, a current, a mesh, or an _Element Orientation_.\

==== _APDL_ script
#let apdl_code = read("../code/apdl.script.txt")
In Ansys Mechanical software, we can write an _APDL_ script to define the physics of the problem. Since we have a steady-state thermal solver (because there is no equivalent solver for electromagnetic problems), we now need to convert thermal elements to electromagnetic elements. Using arguments, we can also easily apply a velocity to the rail and a current to the coil. The script is shown below:
#code(apdl_code, lang: "apdl", lines:(13,66), line-numbers:false)

=== Yamamura Model on Ansys Mechanical
In a first step, we can look at the eddy currents in the rail. In @ec_yam_mc_y10 we can see that they are mainly at the nose and tail of the magnet. In our frame, the electrons move in the positive x-direction and the magnetic field points into the plane, so they are diverted inside the magnet area toward the negative y-direction (positive current density $vb(J)$ points in the opposite direction, i.e., in the positive y-direction). We notice that the currents are not perfectly symmetric but are highest at the rail edges and quenched in the x-direction.
#figure(
 image("../figures/simulation/yam_ec.png", width: 100%),
 caption: [Depiction of the eddy currents in the Yamamura model at speed of $qti("100", "m/s")$ simulated with Ansys Mechanical. The rail is moving from left to right. Top view.]
)<ec_yam_mc_y10>

To retrieve the magnetic field in the air gap we define a surface parallel to the rail in the air gap. On this surface we can then export the magnetic field values and evaluate them.
Since the surface includes all values of the plane through the whole region, we first need to cut by x and y coordinates to get the values inside the air gap.\
We can illustrate the result in a 2D color plot, which is shown for zero speed in @B_2Dprofile_yam_mc_y10. As expected, the magnetic field is evenly distributed in the air-gap cross section at zero speed.


#figure(
 image("../figures/simulation/ColorMapB_2Dprofile_yam_mc_v0.png", width: 100%),
 caption: [Magnetic field 2D air gap profile of the Yamamura model at zero speed.]
)<B_2Dprofile_yam_mc_y10>

#figure(
 image("../figures/simulation/ColorMapdeltaB_2Dprofile_yam_mc_v100.png", width: 100%),
 caption: [Induced magnetic field 2D air gap profile of the Yamamura model at speed of $qti("100","m/s")$.]
)<DeltaB_2Dprofile_yam_mc_y10>

For higher velocities we choose not to plot the absolute value of the magnetic field but the change of the magnetic field compared to the zero speed case, which corresponds to the induced part of the magnetic field. In @DeltaB_2Dprofile_yam_mc_y10 we can see that at the nose we have a large reduction of the magnetic field of around $qty("30", "mT")$ and at the tail we have an increase of around $qty("20", "mT")$.
The value of the induced field also depends on the y-coordinate; here we observe that the values are highest in the middle of the rail and vanish toward the edges. This agrees with our previous considerations in @chapter:general_considerations.

To get more insight into the magnitude of the induced currents and their spatial distribution along the x-axis, we can plot the magnetic field along the x-axis in the air gap. A simulation with the same geometries and velocities as in @B_profile_yam_long is depicted in @B_profile_yam_mc_y10.
#figure(
 image("../figures/simulation/B_profile_yam_mc.svg", width: 100%),
 caption: [Magnetic field profile of the Yamamura model along the x-axis in the air gap at velocity $v=qti("100", "m/s")$. Simulated with Ansys Mechanical. Yoke length: $qti("135", "mm")$, yoke width: $qti("10", "mm")$]
)<B_profile_yam_mc_y10>
We can observe that with a rail width of $qty("10", "mm")$ the relative magnetic flux change is quite moderate with a lowest nose dip (LND) of 4.68% at the front and a highest tail peak (HTP) of 2.99% at the end of the magnet at a speed of $qti("100", "m/s")$. These values are characteristic for the B-profile and depend on the velocity as well as on the geometry of the rail and the yoke (which we will see later). To visualize the change of the magnetic field more clearly, we can plot the change of the magnetic field compared to the zero speed case, which is shown in @deltaB_profile_yam_mc.

#figure(
 image("../figures/simulation/deltaB_profile_yam_mc.svg", width: 100%),
 caption: [Change of magnetic field profile of the Yamamura model along the x-axis in the air gap at $v=qti("100", "m/s")$. Simulated with Ansys Mechanical. Yoke length: $qti("135", "mm")$, yoke width: $qti("10", "mm")$ ]
)<deltaB_profile_yam_mc>


== Comparison between Ansys Maxwell and Ansys Mechanical
To verify the results of the Ansys Mechanical simulation, we can compare the magnetic field profile in the air gap to that obtained with Ansys Maxwell. The comparison is shown in @B_profile_yam_y10_comparison. We can see the same behavior in both simulations: at the nose the induced field points against the applied field which leads to a reduction of the magnetic field, whereas at the tail the induced field points in the same direction as the applied field which leads to an increase of the magnetic field.

#figure(
 grid(columns:2, column-gutter: 1em, row-gutter: 0.5em,
 [#image("../figures/simulation/B_profile_yam_mx_small.svg", width: 100%)],
 [#image("../figures/simulation/B_profile_yam_mc_small.svg", width: 100%)],
 [(a)],[(b)],
 ),
 caption: [Comparison between the magnetic field profile of the Yamamura model simulated with Ansys Maxwell (a) and Ansys Mechanical (b) at speed of $qti("100", "m/s")$. Yoke length: $qti("135", "mm")$, yoke width: $qti("10", "mm")$]
)<B_profile_yam_y10_comparison>

To get a better insight into the differences between the two simulations, we can also compare the change of the magnetic field which is shown in @deltaB_profile_yam_y10_comparison.

#figure(
 grid(columns:2, column-gutter: 1em, row-gutter: 0.5em,
 [#image("../figures/simulation/deltaB_profile_yam_mx_small.svg", width: 100%)],
 [#image("../figures/simulation/deltaB_profile_yam_mc_small.svg", width: 100%)],
 [(a)],[(b)],
 ),
 caption: [Comparison between the change of magnetic field profile of the Yamamura model simulated with Ansys Maxwell (a) and Ansys Mechanical (b) at speed of $qti("100", "m/s")$. Yoke length: $qti("135", "mm")$, yoke width: $qti("10", "mm")$]
)<deltaB_profile_yam_y10_comparison>

The changes in the magnetic field are of the same order of magnitude: the LND is 4.68% in Ansys Mechanical and 6.50% in Ansys Maxwell, and the HTP is 2.99% in Ansys Mechanical and 5.41% in Ansys Maxwell at a speed of $qti("100", "m/s")$. The differences can be explained by the different meshing and solver types used in both simulations.\
We can also compare the resulting braking force. In the Maxwell simulation, the transient plot in @yam_long_force_x converges to a braking force of around $qty("400", "mN")$ at $qti("100", "m/s")$, whereas the Ansys Mechanical simulation yields a braking force of around $qty("340", "mN")$ at the same speed (@Forces_yam_x135y10).\
#figure(
 image("../figures/simulation/F_yam_vsweep.svg", width: 100%),
 caption:[Braking force of the Yamamura model at speeds from $qti("0", "m/s")$ to $qti("300", "m/s")$ simulated with Ansys Mechanical. Yoke length: $qti("135", "mm")$, yoke width: $qti("10", "mm")$.]
)<Forces_yam_x135y10>

In @DeltaB_2Dprofile_yam_mc_y10 we can see that the resolution of the Mechanical simulation is much higher than that of the Maxwell simulation, which can be explained by the higher mesh density in critical regions. Therefore, the Mechanical simulation is more reliable and will be used for the following simulations.



== Yamamura Model
As the simulation with Ansys Mechanical proved to be far more efficient than the one with Ansys Maxwell, we now use it to investigate different parameters of the Yamamura model. First, we study the velocity dependence of the model, then the influence of rail/yoke width, and finally the influence of yoke length.
Unless stated otherwise, the following parameters are used:
- velocity: $qti("100", "m/s")$
- yoke/rail width: $qti("10", "mm")$
- yoke length: $qti("140", "mm")$

=== Velocity dependence
For the velocity dependence, we run the simulation for several velocities from $qti("0", "m/s")$ to $qti("300", "m/s")$. The resulting induced field profiles along the x-axis in the air gap are shown in @deltaB_profile_yam_mc_vsweep for representative velocities.
#figure(
 image("../figures/simulation/deltaB_profile_yam_mc_vsweep.svg", width: 100%),
 caption:[Change in magnetic field profile of the Yamamura model along the x-axis in the air gap at different velocities. Simulated with Ansys Mechanical. Yoke length: $qti("140", "mm")$, yoke width: $qti("10", "mm")$.]
)<deltaB_profile_yam_mc_vsweep>
We see that with increasing velocity the induced field becomes stronger, which is expected since the eddy currents are stronger at higher velocities. The amplitudes of both the nose dip and the tail peak increase with increasing velocity. Along the magnet length, we observe a residual induced field that vanishes slowly toward the end of the magnet and also grows with increasing velocity. The values of the lowest nose dips and highest tail peaks for all velocities are given in @table:LND_HTP_yam_mc_y10.
#figure(
table(
 columns: (auto, auto, auto),
 align: horizon,
 table.header([*Velocity in $m/s$*], [*LND in $unit("mT")$*], [*HTP in $unit("mT")$*]),
 [30], [24.94 (2.49%)], [14.11 (1.41%)],
 [60], [35.83 (3.58%)], [21.57 (2.16%)],
 [100], [47.48 (4.75%)], [30.66 (3.07%)],
 [200], [72.30 (7.23%)], [52.61 (5.26%)],
 [300], [95.16 (9.51%)], [74.51 (7.45%)]
),
caption: [LND and HTP for several velocities in the Yamamura model with a rail width of $qty("10", "mm")$ and an applied magnetic field of $B_0=qty("1000", "mT")$. The values are obtained from the magnetic field profile along the x-axis in the air gap at different velocities.]
)<table:LND_HTP_yam_mc_y10>

#figure(
 image("../figures/simulation/F_yam_vfit.svg", width: 100%),
 caption:[Fit of the braking force of the Yamamura model at speeds from $qti("0", "m/s")$ to $qti("300", "m/s")$ for different yoke widths. Yoke length: $qti("140", "mm")$. The red dots represent the simulated values, whereas the blue lines represent the fit with the function $F(x)=a x^b$.]
)<F_yam_vfit>
We can also look at the braking force of the model at different velocities, as shown in @F_yam_vfit, where the braking force is plotted against velocity for several yoke widths. We can see that with increasing velocity, the braking force increases as well, which is expected since the eddy currents are stronger at higher velocities. The shape of the curve is similar to a square-root function; therefore, we fit the curves with a model function of the form $F(v)=a v^b$. The fitted curves are shown in @F_yam_vfit as blue lines, where the red dots represent the simulated values. The fit is very good, with $R^2$ values above 0.99 for all curves. The fitting parameters are shown in @table:F_yam_vfit_parameters.
#figure(
 table(
 columns: (auto, auto, auto, auto),
 align: horizon,
 table.header([*Yoke width in $unit("mm")$*], [*a*], [*b*], [*$R^2$*]),
 [10], [0.0490], [0.6550], [0.9956],
 [15], [0.1769], [0.5786], [0.9940],
 [20], [0.2917], [0.5921], [0.9972],
 [25], [0.5674], [0.5537], [0.9978],
 [30], [0.9627], [0.5251], [0.9981],
 [35], [1.5037], [0.4993], [0.9982]
 ),
 caption: [Fitted parameters for the braking force of the Yamamura model at different velocities. The fitting is done with the function $F(v)=a v^b$.]
)<table:F_yam_vfit_parameters>
Indeed we see for the exponent $b$ that it is converging towards 0.5 with increasing yoke width, which confirms the square root shape of the curve. The prefactor $a$ is increasing with increasing yoke width, which is expected since a wider yoke leads to stronger eddy currents and thus a stronger braking force.


=== Yoke width dependence
For the yoke width dependence, we run the simulation for several yoke widths from $qti("1", "mm")$ to $qti("38", "mm")$. The resulting induced field profiles along the x-axis in the air gap are shown in @deltaB_yam_ysweep for representative yoke widths.
#figure(
 image("../figures/simulation/deltaB_yam_ysweep.svg", width: 100%),
 caption:[Change in magnetic field profile of the Yamamura model at speed of $qti("100", "m/s")$ for different yoke widths. Yoke length: $qti("140", "mm")$.]
)<deltaB_yam_ysweep>
We observe a behavior similar to the velocity case: with increasing yoke width, the induced field becomes stronger, which is expected since the eddy currents can flow in larger circulations and thus become stronger at larger yoke widths. In contrast to the velocity dependence, however, the curve shape not only shows increased amplitudes but also relaxes much more slowly after the lowest nose dip toward the end of the magnet. This also corresponds to a larger eddy-current circulation flux, with an increased diameter in both the y- and x-directions. The lift and drag forces are now affected not only by the nose and tail regions but also by the middle region of the magnet, which leads to a stronger braking force. The values of the lowest nose dips and highest tail peaks for the representative yoke widths are given in @table:LND_HTP_yam_ysweep.

#figure(
table(
 columns: (auto, auto, auto),
 align: horizon,
 table.header([*Yoke width in $unit("mm")$*], [*LND in $unit("mT")$*], [*HTP in$unit("mT")$*]),
 [10], [47.48 (4.75%)], [30.66 (3.07%)],
 [15], [80.68 (8.07%)], [50.66 (5.07%)],
 [20], [117.28 (11.73%)], [72.53 (7.25%)],
 [25], [155.13 (15.51%)], [94.38 (9.44%)],
 [30], [194.64 (19.46%)], [116.53 (11.65%)],
 [35], [233.62 (23.36%)], [137.67 (13.76%)]
),
caption: [LND and HTP for several yoke widths in the Yamamura model with a velocity of $qti("100", "m/s")$ and an applied magnetic field of $B_0=qty("1000", "mT")$.]
)<table:LND_HTP_yam_ysweep>

The yoke-width dependence of the braking force is shown in @F_yam_yfit, where the braking force is plotted against yoke width for several velocities. We can see that with increasing yoke width, the braking force increases as well, but with a much stronger dependence than for velocity. The shape of the curve is similar to a square function; therefore, we fit the curves again with a model function of the form $F(x)=a x^b$. The fitted curves are shown in @F_yam_yfit as blue lines, where the red dots represent the simulated values. The coefficient of determination $R^2$ is above 0.999 for all velocities, which indicates a very good fit. The fitted parameters are shown in @table:F_yam_yfit_parameters. \
#figure(
 image("../figures/simulation/F_yam_yfit.svg", width: 100%),
 caption:[Fit of the braking force of the Yamamura model for yoke widths from $qty("10", "mm")$ to $qty("35", "mm")$ at different velocities. Yoke length: $qti("140", "mm")$. The red dots represent the simulated values, whereas the blue lines represent the fit with the function $F(x)=a x^b$.]
)<F_yam_yfit>
#figure(
 table(
 columns: (auto, auto, auto, auto),
 align: horizon,
 table.header([*Velocity in $unit("m/s")$*], [*a*], [*b*], [*$R^2$*]),
 [10], [0.0014], [2.3108], [0.9991],
 [30], [0.0029], [2.2400], [0.9996],
 [60], [0.0049], [2.1831], [0.9998],
 [100], [0.0077], [2.1238], [0.9998],
 [200], [0.0160], [2.0190], [0.9998],
 [300], [0.0262], [1.9462], [0.9998]
 ),
 caption: [Fitted parameters for the braking force of the Yamamura model at different velocities. The fitting is done with the function $F(x)=a x^b$.]
)<table:F_yam_yfit_parameters>
For high velocities the exponent $b$ is converging towards 2, which confirms the square shape of the curve. The prefactor $a$ is increasing with increasing velocity, which is expected since a higher velocity leads to stronger eddy currents and thus a stronger braking force.


=== Yoke length dependence
For the yoke length dependence, we run the simulation for several yoke lengths from $qti("100", "mm")$ to $qti("900", "mm")$. The resulting induced field profiles along the x-axis in the air gap are shown in @deltaB_yam_xsweep for representative yoke lengths.
#figure(
 image("../figures/simulation/deltaB_yam_xsweep.svg", width: 100%),
 caption:[Change in magnetic field profile of the Yamamura model at speed of $qti("100", "m/s")$ for different yoke lengths. Yoke width: $qti("10", "mm")$.]
)<deltaB_yam_xsweep>
We observe that with increasing yoke length, no significant change in either the shape or the amplitudes of the induced field profile occurs. This is expected since the eddy currents are mainly induced at the nose and tail of the magnet, so a longer yoke does not lead to stronger eddy currents but only has a larger middle region where the magnetic field is barely affected.

In @F_yam_xsweep we can see the braking force as a function of yoke length for different velocities. As expected, we observe that the braking force is also not affected by yoke length. Therefore, we do not apply a fit to the curves since they are basically constant.

#figure(
 image("../figures/simulation/F_yam_xsweep.svg", width: 100%),
 caption:[Braking force of the Yamamura model at speeds from $qti("0", "m/s")$ to $qti("300", "m/s")$ for different yoke lengths. Yoke width: $qti("10", "mm")$.]
)<F_yam_xsweep>


=== Magnetic field dependence
For the magnetic field dependence, we run the simulation for several current densities from $num("8.38e6")$ to $qti("83.8e6", "A/m^2")$. This results in different applied magnetic fields in the air gap. We expect a linear dependence between applied current density and the resulting magnetic field because of Ampere's law, which states that the magnetic field is proportional to the electric current (see @amperes-law).
#figure(
  image("../figures/simulation/B_yam_x140y10v0_jsweep.svg", width: 100%),
  caption:[Magnetic field profile of the Yamamura model at zero speed for different applied magnetic fields. The magnetic field values inside the magnet are (increasing): $qty("100", "mT"), qty("300", "mT"), qty("500", "mT"), qty("700", "mT"), qty("1000", "mT")$. Yoke length: $qti("140", "mm")$, yoke width: $qti("10", "mm")$.]
)<B_yam_x140y10v0_jsweep>
In @B_yam_x140y10v0_jsweep we can see the magnetic field profile along the x-axis in the air gap at zero speed for different applied electric current densities. We can see that the shape of the profile is the same for all current densities, but the basic mean level of the magnetic field is increasing with increasing current density. Comparing the mean values of the magnetic field for the different current densities, we can confirm a linear dependence between the applied current density and the resulting magnetic field, as shown in @table:B0_jsweep.

#figure(
  table(
    columns: (auto, auto),
    align: horizon,
    table.header([*Current density in $unit("A/m^2")$*], [*Mean magnetic field in $unit("mT")$*]),
    [$num("8.38e6")$], [100.01],
    [$num("25.15e6")$], [300.01],
    [$num("41.92e6")$], [500.02],
    [$num("58.69e6")$], [700.03],
    [$num("83.85e6")$], [1000.05]
  ),
  caption:[Mean magnetic field in the air gap for different applied current densities.]
)<table:B0_jsweep>

Next we are interested in the dependence of the induced magnetic field on the applied current density. For that our magnet (or the rail) needs to be moving, so we run the simulation for a velocity of $qti("100", "m/s")$ for different current densities. The resulting change of the magnetic field compared to the zero speed case is shown in @deltaB_yam_x140y10v100_jsweep.
#figure(
  image("../figures/simulation/B_yam_x140y10v100_jsweep.svg", width: 100%),
  caption:[Change in magnetic field for different applied magnetic field values at a velocity of $qti("100", "m/s")$. Yoke length: $qti("140", "mm")$, yoke width: $qti("10", "mm")$.]
)<deltaB_yam_x140y10v100_jsweep>
We can see a similar behavior as for the velocity sweep in @deltaB_profile_yam_mc_vsweep, i.e. that the amplitudes increase but the shape of the curve is basically the same for all current densities. The values of the lowest nose dips and highest tail peaks for the different current densities are given in @table:LND_HTP_yam_jsweep.
#figure(
  table(
    columns: (auto, auto, auto),
    align: horizon,
    table.header([*$B_0$ in $unit("mT")$*], [*LND in $unit("mT")$*], [*HTP in $unit("mT")$*]),
    [$num("100")$], [4.76 (4.76%)], [3.11 (3.11%)],
    [$num("300")$], [14.29 (4.76%)], [9.32 (3.11%)],
    [$num("500")$], [23.82 (4.76%)], [15.53 (3.11%)],
    [$num("700")$], [33.35 (4.76%)], [21.75 (3.11%)],
    [$num("1000")$], [47.64 (4.76%)], [31.05 (3.11%)]
  ),
  caption:[LND and HTP for several applied magnetic fields in the Yamamura model with a velocity of $qti("100", "m/s")$, a yoke width of $qti("10", "mm")$ and a yoke length of $qti("140", "mm")$.]
)<table:LND_HTP_yam_jsweep>
We see that the values for LND and HTP increase linearly with the applied magnetic field $B_0$ and the relative values are constant at 4.76% and 3.11% respectively, which means that the induced magnetic field is proportional to the applied magnetic field and thus to the applied current density.
#figure(
  image("../figures/simulation/F_yam_jfit.svg", width: 100%),
  caption:[Fitting of the braking force of the Yamamura model against the applied magnetic field with the function $F (x) = a dot x^b$. The red dots represent the simulated values, whereas the blue lines represent the fit.]
)<F_yam_jfit>
In @F_yam_jfit we can see the braking force of the model for different applied current densities. We could have expected a proportional dependence, since the induced magnetic field is proportional to the applied current density. However, the curve shape is more similar to a square function; therefore, we fit the curves with a model function of the form $F(x)=a x^b$. The fitted curves are shown in @F_yam_jfit as blue lines, where the red dots represent the simulated values. Indeed we obtain an exponent of $b=2.0000 plus.minus num("6.65e-7")$, which confirms the square dependence of the braking force on the applied current density. The prefactor $a$ is equal to $num("0.956") plus.minus num("1.36e-6")$ and the $R^2$ value of the fit is $1.0000$. The x values for the fit are converted from current density ($unit("A/m^2")$) to magnetic field ($unit("T")$) using their linear relationship, which must be taken into account when interpreting the prefactor $a$.


=== Braking force fit
We will now compile the results of the velocity, yoke width, yoke length and applied field dependence to conclude a general law for the braking force of the Yamamura model. Since we observed a square root dependence on the velocity, a square dependence on the yoke width and the applied field and no dependence on the yoke length, we will model the braking force with the following function:
$ F_b (v,y,B_0) = C dot B_0^2 y^2 sqrt(v) $
We still have to determine whether the prefactor $C$ is really a constant or whether it also depends on velocity and/or yoke width. Since the fit for the applied field has a perfect $R^2$ value and a negligible error for the exponent, we assume no dependence for $C$ on $B_0$. To check the dependence on $v$ and $y$, we plot the braking force against the function $y^2 sqrt(v)$ for all simulated velocities and yoke widths, as shown in @F_yam_vyfit. Since we conducted all simulations for the velocity and yoke width dependence with the same applied magnetic field of $B_0=qty("1", "T")$, we can divide by 1 to neglect the dependence on $B_0$ in the plot.\
We can see that all values lie on a straight line, which confirms the model function. The fitted line is shown in blue in @F_yam_vyfit, where the red dots represent the simulated values. The fit is good with a coefficient of determination of $R^2=0.9973$. The slope of the fitted line corresponds to the prefactor $C$ and is equal to $C=1241.8$ with a standard error of 4.3.

#figure(
 image("../figures/simulation/F_yam_vyfit.svg", width: 100%),
 caption:[Fitting of the braking force of the Yamamura model against the velocity and yoke width with the function $F_B (v,y) = C y^2 sqrt(v)$. The red dots represent the simulated values, whereas the blue lines represent the fit.]
)<F_yam_vyfit>
We can also derive $C$ by dividing the simulated braking force by the term $y^2 sqrt(v)$ for all simulated velocities and yoke widths, which yields a mean value of $C=1133.9$ with a standard deviation of $126.98$ which is 11.2%. These two methods yield a similar value for $C$, which confirms that it is really a constant and does not depend on the velocity nor on the yoke width. Therefore we can conclude that the braking force of the Yamamura model can be described with the following function:
$ F_b (v,y,B_0) = qty("1241.8","A^2 kg^-1 m^-1.5 s^-2.5") B_0^2 y^2 sqrt(v) $
The unit for $C$ is $unit("N T^-2 * m^-2 * m^-0.5 s^0.5")= unit("A^2 kg^-1 m^-1.5 s^-2.5")$ to ensure that the braking force is in $unit("N")$.
Comparing the constant $C$ to the prefactor $a$ of the fit for the applied field dependence, we first have to apply the yoke width and velocity values of the applied field dependence simulation. For the applied field dependence, we used a yoke width of $y=qti("10", "mm")$ and a velocity of $v=qti("100", "m/s")$. Therefore, we can calculate the expected prefactor for the applied field dependence as $a = C y^2 sqrt(v) = 1241.8 * (0.01)^2 * sqrt(100) = 1.2418$, which is close to the fitted value of $a=0.956$ for the applied field dependence.

The function $F_b (v,y,B_0)$ can be used to predict the braking force of the Yamamura model, where $y$ is both the yoke and rail width. For a conventional geometry, as discussed in the next @section:hyperloop_model, the rail width has to be much larger since both yoke surfaces are exposed to the same side of the rail.
We expect here an even stronger braking force since the eddy currents can flow in larger circulations. This would specifically influence the $C$ constant. The general square root dependence on the velocity and the square dependence on the yoke width and the applied field should still hold.


#pagebreak()
== TUM Hyperloop Model
<section:hyperloop_model>

// #figure(
//  image("../figures/simulation/ColorMapB_2Dprofile_hm_v0.png", width: 95%),
//  caption: [Magnetic field 2D air gap profile of the TUM Hyperloop model at zero speed.]
// )<B_2Dprofile_hm_v0>

// #figure(
//  image("../figures/simulation/ColorMapdeltaB_2Dprofile_hm_v100.png", width: 95%),
//  caption: [Magnetic field 2D air gap profile of the TUM Hyperloop model at zero speed.]
// )<deltaB_2Dprofile_hm_v100>


The original model of the TUM Hyperloop consists of a rail and an electromagnet whose yoke is shaped like a U. Since both yoke surfaces are exposed to the same side of the rail, the rail needs to be wider than in the Yamamura model, which increases the number of mesh elements and thus significantly increases computational cost. However, the Hyperloop model can be used for actual levitation, since a net magnetic force can now act between rail and magnet in the z-direction, whereas in the Yamamura model the forces in the z-direction cancel each other out. Therefore, we also investigate the Hyperloop model with Ansys Mechanical to get better insight into the influence of different parameters on the magnetic field and the resulting forces.

We will start with a smaller dimension of the model to reduce the computational cost, but we will keep the same proportions as in the original model. The dimensions in $unit("mm")$ are given in @table:TUM_model_dimensions:
#figure(
  grid(columns: 2,
  column-gutter: 1em,
  row-gutter: 0.5em,
  [
  #table(
   columns: (auto, auto, auto),
   align: horizon,
   table.header([*Component*], [*Label*], [*Size*]),
   table.cell(rowspan: 4)[*yoke*],
   [yoke_x], [140],
   [yoke_width], [10],
   [yoke_y], [40],
   [yoke_z], [20],
   table.cell(rowspan: 2)[*coil*],
   [coil_thickness], [7.5],
   [coil_padding], [0.2],
   table.cell(rowspan: 3)[*rail*],
   [rail_x], [590],
   [rail_y], [40],
   [rail_z], [1],
   table.cell(rowspan: 1)[*air*],
   [air gap], [1],
  )],
  [#image("../figures/simulation/tum_model.svg", width: 100%)],
  [],[])
)<table:TUM_model_dimensions>

The original-dimension geometry has a yoke length of $qti("1350", "mm")$ (\~ 10x larger), and a yoke width of $qti("3.5", "mm")$ (\~ 3.5x larger), which results in a scaling factor of 35 for the magnetic area of the smaller model.
As in the analysis of the Yamamura model, we simulate the model for different velocities to get insight into the velocity dependence of the magnetic field and the resulting forces. The magnetic field profiles along the x-axis in the air gap for an applied magnetic field of $B_0=qti("484", "mT")$ and different velocities are shown in @B_hurric_x140y10_vsweep.
#figure(
 image("../figures/simulation/B_hurric_x140y10_vsweep.svg", width: 100%),
 caption: [Magnetic field profile of the TUM Hyperloop model along the x-axis in the air gap at several velocities from 0 to $qti("300", "m/s")$. Simulated with Ansys Mechanical. Yoke length: $qti("140", "mm")$, yoke width: $qti("10", "mm")$, applied magnetic field: $B_0=qti("484", "mT")$.]
)<B_hurric_x140y10_vsweep>
We can observe a similar behavior as in the Yamamura model: at the nose the induced field points against the applied field which leads to a reduction of the magnetic field, whereas at the tail the induced field points in the same direction as the applied field which leads to an increase of the magnetic field. Compared to the Yamamura model with the same dimensions for yoke length and width the amplitudes of the nose dip and tail peak are much stronger in the Hyperloop model. This is even more noticeable when comparing the change of the magnetic field compared to the zero speed case, which is shown in @deltaB_profile_yam_mc_vsweep for the Yamamura model and in @deltaB_hurric_x140y10_vsweep for the Hyperloop model.
#figure(
 image("../figures/simulation/deltaB_hurric_x140y10_vsweep.svg", width: 100%),
 caption: [Change of magnetic field profile of the TUM Hyperloop model along the x-axis in the air gap at several velocities from 0 to $qti("300", "m/s")$. Yoke length: $qti("140", "mm")$, yoke width: $qti("10", "mm")$.]
)<deltaB_hurric_x140y10_vsweep>
The values of the lowest nose dips and highest tail peaks for all velocities are given in @table:LND_HTP_hurric_vsweep and are roughly three times higher than for the Yamamura model (@table:LND_HTP_yam_mc_y10). This can be explained by the fact that in the Hyperloop model the eddy currents can flow in larger circulations, because the rail width, which equals the yoke width in the Yamamura model, has to be wider in the Hyperloop model to expose both yoke surfaces to the same side of the rail.
#figure(
table(
 columns: (auto, auto, auto),
 align: horizon,
 table.header([*Velocity in $m/s$*], [*LND in $unit("mT")$*], [*HTP in $unit("mT")$*]),
 [30], [40.20 (8.31%)], [26.79 (5.54%)],
 [60], [59.27 (12.26%)], [38.71 (8.01%)],
 [100], [78.42 (16.22%)], [52.18 (10.79%)],
 [200], [113.13 (23.40%)], [80.50 (16.65%)],
 [300], [139.68 (28.89%)], [104.88 (21.69%)]
),
caption: [LND and HTP for several velocities in the TUM Hyperloop model with a rail width of $qty("10", "mm")$ and an applied magnetic field of $B_0=qty("480", "mT")$. The values are obtained from the magnetic field profile along the x-axis in the air gap at different velocities.]
)<table:LND_HTP_hurric_vsweep>
A further indication that the eddy currents flow in larger circulations can be seen when comparing the magnetic field profiles along the x-axis with the ones of the yoke width sweep of the Yamamura model in @deltaB_yam_ysweep. In both cases, the profiles exhibit not only increased amplitudes but also a significantly slower recovery from the lowest nose dip toward the end of the magnet. This behavior is characteristic of increasing yoke width in the Yamamura model, but is now observed even more strongly in the Hyperloop configuration. This suggests that the eddy currents circulate over larger effective diameters, both in the transverse (y) direction and along the direction of motion (x).
Comparing the relative values of the LND and HTP for the Hyperloop model at a velocity of $qti("100", "m/s")$ with those obtained from the yoke width sweep of the Yamamura model at the same velocity shows that they are similar to the ones for a yoke width of approximately $qty("25", "mm")$ in the Yamamura model.
For this configuration of the Hyperloop model that would mean that we can transfer the results of the Yamamura model by applying a scaling factor of approximately $2.5$ for the yoke width.

Next we want to look at the braking force of the Hyperloop model at different velocities, as shown in @Fb_hm_vfit, where the braking force is plotted against velocity.
#figure(
  image("../figures/simulation/Fb_hm_vfit.svg", width: 100%),
  caption:[Fit of the braking force of the TUM Hyperloop model at speeds from $qti("0", "m/s")$ to $qti("300", "m/s")$ for a yoke width of $qty("10", "mm")$. Yoke length: $qti("140", "mm")$. The red dots represent the simulated values, whereas the blue line represents the fit with the function $F(x)=a sqrt(x)$.]
)<Fb_hm_vfit>
As expected from the analysis of the Yamamura model, the curve shape is similar to a square-root function; therefore, we fit the curve with a model function of the form $F(x)=a sqrt(x)$. We get for the fit a coefficient of determination of $R^2=0.9902$ and a prefactor of $a=0.1203$ with a standard error of 0.0030.
To compare the prefactor $a$ with the constant $C$ of the Yamamura braking force model, the yoke width and magnetic field values of the Hyperloop configuration must first be inserted into the Yamamura expression. For the Hyperloop model, a yoke width of $y=qti("10", "mm")$ and an applied magnetic field of $B_0=qti("484", "mT")$ were used. The expected prefactor for the velocity dependence is therefore
#set math.equation(numbering: none)
$ a = C B_0^2 y^2 = 1241.8 * (0.484)^2 * (0.01)^2 = 0.02909 $.
The fitted value $a=0.1203$ is approximately $4.14$ times larger than this estimate. Since the induced field in the Hyperloop model is approximately $2.5$ times larger than in the Yamamura model and the braking force scales with the square of the induced magnetic field, a scaling factor of about $6.25$ would be expected. The discrepancy between the estimated and fitted values can be attributed to the approximations involved in both the scaling argument and the fitting procedure. Nevertheless, the agreement in order of magnitude supports the validity of using the Yamamura model as a basis for estimating the braking force in the Hyperloop configuration.\
Based on this, the braking force for the full-scale Hyperloop geometry can be approximated. The original design uses a yoke width of $y=qti("35", "mm")$ and an applied magnetic field of approximately $B_0=qti("550", "mT")$, depending on the load conditions and air gap. For a velocity of $v=qti("100", "m/s")$, the braking force per magnet arrangement is estimated as
$ F_b = C B_0^2 y^2 sqrt(v) = 4.14*1241.8 * (0.55)^2 * (0.035)^2 * sqrt(100) = qty("19.05", "N") $.
The TUM Hyperloop pod consists of four such magnet arrangements, resulting in a total braking force of approximately $qty("76.2", "N")$. Although this is a very rough estimate, it provides a useful indication of the expected order of magnitude for the braking force in the full-scale system.

In contrast to the Yamamura model, the Hyperloop model also has a net lift force in the z-direction, which is shown in @F_hm_vsweep for different velocities. We can see that the lift force is decreasing with increasing velocity. As stated by Yamamura @eq:lift_force, the lift force is calculated by the integration of the total magnetic field, i.e. the sum of the applied and induced field, over the surface of the magnet. As shown in @B_hurric_x140y10_vsweep, the average magnetic field in the air gap is decreasing with increasing velocity, only at the tail we have an increase of the magnetic field which increases there the lift force. But it is not enough to compensate the decrease of the magnetic field at the nose and the middle region, which leads to a net decrease of the lift force. This net decrease of the lift force can be interpreted as the oriented surface integration of the plot in @deltaB_hurric_x140y10_vsweep.


#figure(
  image("../figures/simulation/F_hm_vsweep.svg", width: 100%),
  caption:[Braking force and Lift force of the TUM Hyperloop model at speeds from $qti("0", "m/s")$ to $qti("300", "m/s")$. Yoke length: $qti("140", "mm")$, yoke width: $qti("10", "mm")$.]
)<F_hm_vsweep>
