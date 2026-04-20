#pagebreak()

#import "@preview/physica:0.9.6": *
#import "@preview/unify:0.7.1": *
#import "@preview/codedis:0.3.0": code

#let qti(value, unit) = qty(value, unit, per:"/")

= Simulation<chapter:simulation>
The simulation for this thesis is conducted using two different software packages: Ansys Maxwell 2025 R2 (Ansys Inc., USA) and Ansys Mechanical 2025 R2 (Ansys Inc., USA).

== Ansys Maxwell
Since Ansys Maxwell is designed for electromagnetic simulations, it is the most intuitive choice for our problem. In the following sections, we discuss the different steps to prepare the simulation and the different options available in Ansys Maxwell for each step.

=== Solver Type
There are several solver types available in Maxwell, such as _Magnetostatic_, _Electrostatic_, and _Eddy Current_. The only solver relevant to our use case is _Transient_, since it includes motion. \
For transient simulations, Maxwell offers two formulations: the $vb(T)-Omega$ formulation and the $vb(A)-Phi$ formulation. However, Maxwell allows motion only with the $vb(T)-Omega$ formulation. Therefore, the $vb(A)-Phi$ formulation is not relevant for this study.\
The $vb(T)-Omega$ formulation is also the default option for the _Transient_ solver, where the order of the magnetic scalar potential $Omega$ is 2 and the order of the electric vector potential $vb(T)$ is 1 @ansys_3D_transient_solver.
For motion problems, Maxwell uses a fixed coordinate system for Maxwell's equations in both the moving and the stationary parts of the model. This eliminates the explicit motion term, so there is no $vb(v) times vb(B)$ term in the current-density equation. Instead, in the stationary frame the magnetic field changes over time, so Maxwell's third equation @maxwell_E2 can be applied. A combination of Maxwell's third and fourth equations @maxwell_E2 and @maxwell_H2 as well as Ohm's law @ohms_law results in the following differential equation:
$ curl 1/sigma curl vb(H) + pdv(vb(B),t) = 0 $
Together with Maxwell's second equation @maxwell_B1 this set of two equations yields the physical description of the problem.
=== Meshing
There are different meshing methods in Ansys that can be applied to a solid. First, Ansys automatically creates an initial mesh, which is then refined by the user in certain regions. \
For the initial mesh, the available methods are @ansys_maxwell_initialmeshsettings:
- Auto (default): automatically selects the mesher, mostly TAU
- Tau: well suited for curved surfaces
- (advanced) Tau Flex Meshing: may reduce meshing time, provides a mesh even for complex geometries
- Classic: uses the Bowyer algorithm. Well suited for geometries with many thin surfaces
- PhiPlus: efficient meshes for designs with layout components
In this thesis, the Auto method is used for the initial meshing. \
In a second step, the mesh is refined in the regions of interest. There are also different methods available for mesh refinement:
- length-based mesh inside an object: applies a mesh inside the whole object with a density specified by the _maximum_length_ parameter
- length-based mesh on object face: applies a mesh on the surface of an object which gets coarser with distance from the surface. Its density is specified by the _maximum_length_ parameter
- skin depth-based mesh on object face: applies a mesh on the surface of an object which is well suited for skin effects like eddy currents. The density on the surface is specified by _triangulation_max_length_, whereas the depth into the object is specified by _skin_depth_ and the number of layers by _layers_number_.
Maxwell also automatically adapts the mesh in the vicinity of finely meshed areas.



=== Motion
<section:Motion>
Maxwell 3D's _Transient_ solution type offers the option to add motion to an object. This is done by defining a motion band, i.e., a box that wraps the moving object. It is important to note that only one object is allowed inside the motion band. If your object consists of several parts, e.g. a yoke and coil that should move together, you must wrap them inside an inner band, which then moves inside the motion band.\
Unfortunately, there is a catch with the mesh of the moving band: in contrast to other objects, which can have different mesh densities (e.g. only dense mesh at one surface), Ansys always applies the highest density of the motion band to the whole band as a length-based mesh inside an object. In other words, if we have only a small region of interest, such as the air gap between magnet and rail where we need a high-density mesh, this high-density mesh is not only applied to the region of the moving band located in the air gap but to the entire moving band. This increases computational costs dramatically.\
There are basically two options for implementing the motion: either move the magnet (yoke and coil) under the rail, or keep the magnet stationary and move the rail. The latter requires a longer moving band in the x-direction (direction of motion), but it can be built much smaller in the z-direction because the eddy currents occur mainly at the surface, which allows us to model a very thin rail. With a moving rail, the moving band's volume is significantly smaller, which reduces computation time and is therefore chosen in this study.\
Another option is to build Yamamura's alternative model as depicted in  @fig:yamamura_simplified. This allows an even smaller moving band volume since the rail is considerably smaller in the y-direction.



=== Yamamura Model on Ansys Maxwell
#figure(
 image("../figures/simulation/yamamura_y10.png", width: 100%),
 caption: [Depiction of the Yamamura model recreated in Ansys Maxwell.]
)<yamamura_recreated>
As discussed in @section:Motion the computational cost for the Yamamura model is significantly lower than that of the conventional model, since the rail and thus the moving band can have considerably smaller volumes. This is why the model is recreated in Ansys Maxwell as shown in @yamamura_recreated.
The dimensions of the yoke and the rail are given in $unit("mm")$ in @table:yam_v100_mx:
#figure(
table(
 columns: (auto, auto, auto),
 align: horizon,

 table.header([*Component*], [*Size*], [*Value*]),
 table.cell(rowspan: 1)[*yoke*],
 [yoke_x], [135],
 // [yoke_y], [x],
 // [yoke_z], [x],
 table.cell(rowspan: 3)[*rail*],
 [rail_x], [245],
 [rail_y], [10],
 [rail_z], [1],
 table.cell(rowspan: 1)[*air gap*],
 [air_z], [1],
),
caption:[Geometry of the yoke and the rail in the Yamamura model. The dimensions are given in $unit("mm")$.]
)<table:yam_v100_mx>
\
*Simulation preparation*\
There are several steps to prepare the simulation:
1. Create the geometry of the different components, such as the rail, yoke, coil, and air gap.
2. Assign current to the coils and turn on eddy effects for the rail.
3. Assign motion to the rail.
4. Create a setup that defines the simulation parameters.
5. Analyze the simulation setup.

In a first simulation, we create the geometry in the dimensions described above and assign a velocity to the rail of $qti("100000", "mm/s")$ which is $qti("100", "m/s")$.
Since the mesh density is about $qti("1", "mm")$ and the velocity is $qti("100", "m/s")$, a time step of $qti("1e-5", "s")$ is chosen.
Former tests have shown that after around 20-30 time steps, a steady state is reached, so the eddy currents are stable. To increase confidence in this result, we chose 90 time steps in this run.\
#figure(
 image("../figures/simulation/eddy_currents_long.png", width: 100%),
 caption: [Depiction of the eddy currents in the Yamamura model at a speed of $qti("100", "m/s")$. The rail is moving from left to right. Top view.]
)<eddy_currents_long>
In @eddy_currents_long we can see the eddy currents in the rail. They are basically only at the nose and tail of the magnet. In our frame, the electrons move in the positive x-direction and the magnetic field points into the plane, so they get diverted inside the magnet area toward the negative y-direction. Outside the magnet area, the electrons move back to the positive y-edge of the rail due to the electric fields created by charge displacement. This leads to a closed current loop, which is clockwise at the nose and counterclockwise at the tail of the magnet.\
#figure(
 image("../figures/simulation/yam_long_force_x.svg", width: 100%),
 caption: [Braking force of the Yamamura model at speed of $qti("100", "m/s")$ over time to observe the steady-state.]
)<yam_long_force_x>
The braking force over time is depicted in @yam_long_force_x. Since this is a transient simulation, the force is not constant but changes over time until it reaches equilibrium. We can see that after around $qty("500", "us")$ (50 time steps), the force is stable, which confirms that equilibrium is reached within 90 time steps. The braking force is around $qty("400", "mN")$ and has negative values because it points against the direction of motion.\
If we insert the geometry parameters of the simulation into the Yamamura model, it yields a braking force of around $qty("3.83", "N")$, which is one order of magnitude larger than the one obtained in the simulation.

Since in the Yamamura geometry the yoke surfaces embrace the rail on both sides, the magnetic forces on the rail (or the magnet) in z-direction, which correspond to the lift force, cancel each other out, so that it is pointless to look at the lift force in this model. To study the lift force, we will look at the conventional model in the following sections.

#figure(
 image("../figures/simulation/B_profile_yam_mx_v100.svg", width: 100%),
 caption: [Magnetic field profile of the Yamamura model at speed of $qti("0", "m/s")$ (at $t=0$) and $qti("100", "m/s")$ (at $t=qti("0","s")$).]
)<B_profile_yam_long>
In @B_profile_yam_long we can see the magnetic field profile in the air gap at zero speed and at $qti("100", "m/s")$. We can see that at the nose of the magnet the magnetic field is reduced due to the induced field which points against the applied field, whereas at the tail of the magnet the magnetic field is increased due to the induced field which points in the same direction as the applied field. We can identify different regions, where we can describe a characteristic behavior of the magnetic field: at the nose region we see the highest drop of the magnetic field, which starts at $6.3 %$ (at $x=qty("-6.7","cm")$) and then decreases to around $3.1%$ (at $x=qty("-4.5","cm")$). In the middle region the magnetic field comes slowly back to the undisturbed value which it reaches at around $x=qty("3","cm")$. At the tail region the magnetic field is increased and reaches its maximum peak at around $x=qty("6.75","cm")$ which is the very end of the magnet. Here the magnetic field increases up to $5.8%$ compared to the zero speed case.\
To get a better insight into the change of the magnetic field, we can plot the difference between the magnetic field at $qti("100", "m/s")$ and the magnetic field at zero speed, which is shown in @deltaB_profile_yam_mx_y10.
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
We can also compare the magnetic field profile at $qti("100", "m/s")$ to the one obtained with the analytical model of Yamamura. The profiles have different forms: whereas the simulation shows a drop in magnetic field at the nose and a peak at the tail, the Yamamura model shows a complete shift of the magnetic field profile in the x-direction toward the tail.



== Simulation with Ansys Mechanical
The simulation with Ansys Maxwell software is very inefficient for several reasons. The main reason is that with Ansys Maxwell we can only conduct a transient setup for our problem, even if we are interested only in a steady-state solution. This requires, on one hand, a more complex solution and, on the other hand, a larger rail geometry. Since the fine mesh must be distributed over the whole rail volume due to Ansys Maxwell restrictions, this leads to very inefficient use of the fine mesh, as described in @section:Motion. Ansys Maxwell is also not optimized for parallel computing, so all calculations run on a single thread. This leads to very long computation times, namely around three weeks for a model with geometries as described in @table:yam_v100_mx. Therefore, a different approach is tested with Ansys Mechanical software using an unconventional solver type for this problem, namely a steady-state thermal solver.

=== Description of the setup
The whole setup is embedded in the Ansys Workbench software, where the geometry is created in Ansys Discovery and then imported to Ansys Mechanical.
==== Geometry
#let geo_code = read("../code/yamamura_geo.py")
The setup is built with Ansys Discovery software via PyAnsys Geometry. There are five bodies created in the model: the rail, the yoke, the coil, the (finely meshed) air gap, and a region box surrounding the whole model.
The air gap body is actually not the whole air gap between rail and yoke but only a small strip in it, along which we want to observe the magnetic field with high resolution.
Here, care must be taken not to overlap the different bodies; this is done, for example, by cutting out the bodies from the region.
#code(geo_code, lines:(182,182), line-numbers:false)
\
For a successful meshing, all bodies must be combined using a shared topology.
#code(geo_code, lines:(198,198), line-numbers:false)

==== Material Data
The model consists of three different materials taken from the General_Materials library of Ansys: Air, Copper Alloy and Gray Cast Iron. The material properties are given in the following @table:materials.

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
Since we are using a steady-state thermal solver, we need to assign an arbitrary value for _Isotropic Thermal Conductivity_ to each material. This value is absolutely irrelevant for the solution, but it is needed for the Ansys solver to start the simulation.
==== Meshing
All components except the region box get a finer mesh. The coil and the yoke body are assigned a _Body Mesh Sizing_ of $qty("1.5", "mm")$. Additionally, the yoke is assigned a _Patch Conforming Method_ that requires a mesh of _Tetrahedrons_ instead of _Hexahedrons_, which is the default for the other bodies.
The air gap body is assigned with a _Body Mesh Sizing_ of $qty("0.1", "mm")$ to ensure a high resolution of the magnetic field in this region.
For the rail we apply three mesh sizing methods along the edges: along the x-edge we assign an _Edge Mesh Sizing_ of $qty("0.4", "mm")$, along the y-edge we assign an _Edge Mesh Sizing_ of $qty("0.5", "mm")$, and along the z-edge we assign an _Edge Mesh Sizing_ of $qty("0.1", "mm")$, with the latter two using a bias that makes the mesh finer on the surfaces and coarser in the middle of the rail.

==== Additional preparations
To apply a current to the coil, we need to define an _Element Orientation_ with the y-coordinate along the current direction.\
It is often convenient, and necessary for the _APDL_ script, to define a _Named Selection_ for bodies, surfaces, and edges where we want to assign a velocity, a current, a mesh, or an _Element Orientation_.\

==== _APDL_ script
#let apdl_code = read("../code/apdl.script.txt")
In Ansys Mechanical software, we can write an _APDL_ script to define the physics of the problem. Since we have a steady-state thermal solver (because there is no equivalent solver for electromagnetic problems), we now need to convert thermal elements to electromagnetic elements. Using arguments, we can also easily apply a velocity to the rail and a current to the coil. The script is shown below:
#code(apdl_code, lang: "apdl", lines:(13,66), line-numbers:false)

=== Yamamura Model on Ansys Mechanical
In a first step, we can look at the eddy currents in the rail. In @ec_yam_mc_y10 we can see that they are basically only at the nose and tail of the magnet. In our frame, the electrons move in the positive x-direction and the magnetic field points into the plane, so they are diverted inside the magnet area toward the negative y-direction (positive current density $vb(J)$ points in the opposite direction, i.e., in the positive y-direction). We notice that the currents are not perfectly symmetric but are highest at the rail edges and quenched in the x-direction.
#figure(
 image("../figures/simulation/yam_ec.png", width: 100%),
 caption: [Depiction of the eddy currents in the Yamamura model at speed of $qti("100", "m/s")$ simulated with Ansys Mechanical. The rail is moving from left to right. Top view.]
)<ec_yam_mc_y10>

For retrieving the magnetic field in the air gap we define a surface parallel to the rail in the air gap. On this surface we can then export the magnetic field values and evaluate them.
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


== Comparison Ansys Maxwell and Ansys Mechanical
To verify the results of the Ansys Mechanical simulation, we can compare the magnetic field profile in the air gap to the one obtained with Ansys Maxwell. The comparison is shown in @B_profile_yam_y10_comparison. We can see the same behavior in both simulations: at the nose the induced field points against the applied field which leads to a reduction of the magnetic field, whereas at the tail the induced field points in the same direction as the applied field which leads to an increase of the magnetic field.

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
 table.header([*Velocity in $m/s$*], [*LND in$unit("mT")$*], [*HTP in$unit("mT")$*]),
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
 caption:[Fit of the braking force of the Yamamura model at speeds from $qti("0", "m/s")$ to $qti("300", "m/s")$ for different yoke widths $num("10"), num("15"), num("20"),num("25"),num("30") "and" qti("35", "mm")$. Yoke length: $qti("140", "mm")$. The red dots represent the simulated values, whereas the blue lines represent the fit with the function $F(v)=a v^b$.]
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
We observe a behavior similar to the velocity case: with increasing yoke width, the induced field becomes stronger, which is expected since the eddy currents can flow in larger circulations and thus become stronger at larger yoke widths. In contrast to velocity dependence, however, the curve shape not only shows increased amplitudes but also relaxes much more slowly after the lowest nose dip toward the end of the magnet. This also corresponds to a larger eddy-current circulation flux, with an increased diameter in both the y- and x-directions. The lift and drag forces are now affected not only by the nose and tail regions but also by the middle region of the magnet, which leads to a stronger braking force. The values of the lowest nose dips and highest tail peaks for the representative yoke widths are given in @table:LND_HTP_yam_ysweep.

#figure(
table(
 columns: (auto, auto, auto),
 align: horizon,
 table.header([*Yoke width in $unit("mm")$*], [*LND in$unit("mT")$*], [*HTP in$unit("mT")$*]),
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
 caption:[Fit of the braking force of the Yamamura model for yoke widths from $qty("10", "mm")$ to $qty("35", "mm")$ at different velocities $qti("10","m/s"), qti("30","m/s"), qti("60","m/s"), qti("100","m/s"), qti("200","m/s"), qti("300","m/s")$. Yoke length: $qti("140", "mm")$. The red dots represent the simulated values, whereas the blue lines represent the fit with the function $F(x)=a x^b$.]
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


=== B field dependence
For the B field dependence, we run the simulation for several current densities from $num("8.38e6")$ to $qti("83.8e6", "A/m^2")$. This results in different applied magnetic fields in the air gap. We expect a linear dependence of applied currents density and the resulting magnetic field because of Ampere's law, which states that the magnetic field is proportional to the electric current (see @amperes-law).
#figure(
  image("../figures/simulation/B_yam_x140y10v0_jsweep.svg", width: 100%),
  caption:[Magnetic field profile of the Yamamura model at zero speed for different applied magnetic fields. The B field values inside the magnet are (increasing): $qty("100", "mT"), qty("300", "mT"), qty("500", "mT"), qty("700", "mT"), qty("1000", "mT")$. Yoke length: $qti("140", "mm")$, yoke width: $qti("10", "mm")$.]
)<B_yam_x140y10v0_jsweep>
In @B_yam_x140y10v0_jsweep we can see the magnetic field profile along the x-axis in the air gap at zero speed for different applied electric current densities. We can see that the shape of the profile is the same for all current densities, but the basic mean level of the magnetic field is increasing with increasing current density. Comparing the mean values of the magnetic field for the different current densities, we can confirm a linear dependence between the applied current density and the resulting magnetic field, as shown in @table:B0_jsweep.

#figure(
  table(
    columns: (auto, auto),
    align: horizon,
    table.header([*Current density in $unit("A/m^2")$*], [*Mean B field in $unit("mT")$*]),
    [$num("8.38e6")$], [100.01],
    [$num("25.15e6")$], [300.01],
    [$num("41.92e6")$], [500.02],
    [$num("58.69e6")$], [700.03],
    [$num("83.85e6")$], [1000.05]
  ),
  caption:[Mean magnetic field in the air gap for different applied current densities.]
)<table:B0_jsweep>

Next we are interested in the dependency of the induced magnetic field on the applied current density. For that our magnet (or the rail) needs to be moving, so we run the simulation for a velocity of $qti("100", "m/s")$ for different current densities. The resulting change of the magnetic field compared to the zero speed case is shown in @deltaB_yam_x140y10v100_jsweep.
#figure(
  image("../figures/simulation/B_yam_x140y10v100_jsweep.svg", width: 100%),
  caption:[]
)<deltaB_yam_x140y10v100_jsweep>
We can see a similar behavior as for the velocity sweep in @deltaB_profile_yam_mc_vsweep, i.e. that the amplitude increase but the shape of the curve is basically the same for all current densities. The values of the lowest nose dips and highest tail peaks for the different current densities are given in @table:LND_HTP_yam_jsweep.
#figure(
  table(
    columns: (auto, auto, auto),
    align: horizon,
    table.header([*$B_0$ in $unit("mT")$*], [*LND in$unit("mT")$*], [*HTP in$unit("mT")$*]),
    [$num("100")$], [4.76 (4.76%)], [3.11 (3.11%)],
    [$num("300")$], [14.29 (4.76%)], [9.32 (3.11%)],
    [$num("500")$], [23.82 (4.76%)], [15.53 (3.11%)],
    [$num("700")$], [33.35 (4.76%)], [21.75 (3.11%)],
    [$num("1000")$], [47.64 (4.76%)], [31.05 (3.11%)]
  ),
  caption:[LND and HTP for several applied magnetic fields in the Yamamura model with a velocity of $qti("100", "m/s")$, a yoke width of $qti("10", "mm")$ and a yoke length of $qti("140", "mm")$.]
)<table:LND_HTP_yam_jsweep>
We see that the values for LND and HTP are linear increasing with the applied magnetic field $B_0$ and the relativ values are constant at 4.76% and 3.11% respectively, which means that the induced magnetic field is proportional to the applied magnetic field and thus to the applied current density.

In @F_yam_jfit we can see the braking force of the model for different applied current densities. We could have expected a proportional dependency, since the induced magnetic field is proportional to the applied current density. However, the curve shape is more similar to a square function; therefore, we fit the curves with a model function of the form $F(x)=a x^b$. The fitted curves are shown in @F_yam_jfit as blue lines, where the red dots represent the simulated values. Indeed we get as exponent a value of $b=2.0000 plus.minus num("6.65e-7")$, which confirms the square dependency of the braking force on the applied current density. The prefactor $a$ is equal to $num("9.573e-7") plus.minus num("5.76e-12")$ and the $R^2$ value of the fit $1.0000$.

#figure(
  image("../figures/simulation/F_yam_jfit.svg", width: 100%),
  caption:[Fitting of the braking force of the Yamamura model against the applied magnetic field with the function $F (x) = a dot x^b$. The red dots represent the simulated values, whereas the blue lines represent the fit.]
)<F_yam_jfit>


=== Braking force fit
We will now compile the results of the velocity, yoke width, yoke length and applied field dependence to conclude a general law for the braking force of the Yamamura model. Since we observed a square root dependency on the velocity, a square dependency on the yoke width and the applied field and no dependency on the yoke length, we will model the braking force with the following function:
$ F_b (v,y,B_0) = C dot B_0^2 y^2 sqrt(v) $
We still have to determine whether the prefactor $C$ is really a constant or whether it also depends on velocity and/or yoke width. Since the fit for the applied field has a perfect $R^2$ value and a neglectable error for the exponent, we assume no dependency for $C$ on $B_0$. To check the dependency on $v$ and $y$, we plot the braking force against the function $y^2 sqrt(v)$ for all simulated velocities and yoke widths, as shown in @F_yam_vyfit. Since we conducted all simulations for the velocity and yoke width dependence with the same applied magnetic field of $B_0=qty("1", "T")$, we can devide by 1 to neglect the dependency on $B_0$ in the plot.\
We can see that all values lie on a straight line, which confirms the model function. The fitted line is shown in blue in @F_yam_vyfit, where the red dots represent the simulated values. The fit is good with a coefficient of determination of $R^2=0.9973$. The slope of the fitted line corresponds to the prefactor $C$ and is equal to $C=1241.8$ with a standard error of 4.3.

#figure(
 image("../figures/simulation/F_yam_vyfit.svg", width: 100%),
 caption:[Fitting of the braking force of the Yamamura model against the velocity and yoke width with the function $F_B (v,y) = C y^2 sqrt(v)$. The red dots represent the simulated values, whereas the blue lines represent the fit.]
)<F_yam_vyfit>
We can also derive $C$ by dividing the simulated braking force by the term $y^2 sqrt(v)$ for all simulated velocities and yoke widths, which yields a mean value of $C=1133.9$ with a standard deviation of $126.98$ which is 11.2%. These two methods yield a similar value for $C$, which confirms that it is really a constant and does not depend on the velocity nor on the yoke width. Therefore we can conclude that the braking force of the Yamamura model can be described with the following function:
$ F_b (v,y,B_0) = qty("1241.8","A^2 kg^-1 m^-1.5 s^-2.5") B_0^2 y^2 sqrt(v) $
The unit for $C$ is $unit("N T^-2 * m^-2 * m^-0.5 s^0.5")= unit("A^2 kg^-1 m^-1.5 s^-2.5")$ to ensure that the braking force is in $unit("N")$.

This function can be used to predict the braking force of the Yamamura model, where $y$ is both the yoke and rail width. For a conventional geometry, as discussed in the next @section:hyperloop_model, the rail width has to be much larger since both yoke surfaces are exposed to the same side of the rail.
We expect here an even stronger braking force since the eddy currents can flow in larger circulations. This would specifically influence the $C$ constant. The general square root dependency on the velocity and the square dependency on the yoke width and the applied field should still hold.


#pagebreak()
== TUM Hyperloop Model
<section:hyperloop_model>
The original model of the TUM Hyperloop consists of a rail and an electromagnet whose yoke is shaped like a U. Since both yoke surfaces are exposed to the same side of the rail, the rail needs to be wider than in the Yamamura model, which increases the number of mesh elements and thus significantly increases computational cost. However, the Hyperloop model can be used for actual levitation, since a net magnetic force can now act between rail and magnet in the z-direction, whereas in the Yamamura model the forces in the z-direction cancel each other out. Therefore, we also investigate the Hyperloop model with Ansys Mechanical to get better insight into the influence of different parameters on the magnetic field and the resulting forces.

We will start with a smaller dimension of the model to reduce the computational cost, but we will keep the same proportions as in the original model. The dimensions in $unit("mm")$ are given in the following table:
#table(
 columns: (auto, auto, auto),
 align: horizon,
 table.header([*Component*], [*Size*], [*Value*]),
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
)
The original-dimension geometry has a yoke length of $qti("1350", "mm")$ (\~ 10x larger), and a yoke width of $qti("3.5", "mm")$ (\~ 3.5x larger), which results in a scaling factor of 35 for the magnetic area of the smaller model.

#figure(
 image("../figures/simulation/B_hurric_x140y10_vsweep.svg", width: 100%),
 caption: [Magnetic field profile of the TUM Hyperloop model along the x-axis in the air gap at several verlocities from 0 to $qti("300", "m/s")$ . Simulated with Ansys Mechanical. Yoke length: $qti("140", "mm")$, yoke width: $qti("10", "mm")$.]
)<B_hurric_x140y10_vsweep>

#figure(
 image("../figures/simulation/deltaB_hurric_x140y10_vsweep.svg", width: 100%),
 caption: [Change of magnetic field profile of the TUM Hyperloop model along the x-axis in the air gap at several verlocities from 0 to $qti("300", "m/s")$ . Yoke length: $qti("140", "mm")$, yoke width: $qti("10", "mm")$.]
)<deltaB_hurric_x140y10_vsweep>



#figure(
table(
 columns: (auto, auto, auto),
 align: horizon,
 table.header([*Velocity in $m/s$*], [*LND in$unit("mT")$*], [*HTP in$unit("mT")$*]),
 [30], [40.20 (8.31%)], [26.79 (5.54%)],
 [60], [59.27 (12.26%)], [38.71 (8.01%)],
 [100], [78.42 (16.22%)], [52.18 (10.79%)],
 [200], [113.13 (23.40%)], [80.50 (16.65%)],
 [300], [139.68 (28.89%)], [104.88 (21.69%)]
),
caption: [LND and HTP for several velocities in the TUM Hyperloop model with a rail width of $qty("10", "mm")$ and an applied magnetic field of $B_0=qty("480", "mT")$. The values are obtained from the magnetic field profile along the x-axis in the air gap at different velocities.]
)<table:LND_HTP_hurric_vsweep>


#figure(
  image("../figures/simulation/Fb_hm_vfit.svg", width: 100%),
  caption:[Fit of the braking force of the TUM Hyperloop model at speeds from $qti("0", "m/s")$ to $qti("300", "m/s")$ for a yoke width of $qty("10", "mm")$. Yoke length: $qti("140", "mm")$. The red dots represent the simulated values, whereas the blue line represents the fit with the function $F(v)=a sqrt(v)$.]
)<Fb_hm_vfit>

Fitted parameter: a=0.1203±0.0030, R²=0.9902

#figure(
  image("../figures/simulation/F_hm_vsweep.svg", width: 100%),
  caption:[Braking force and Lift force of the TUM Hyperloop model at speeds from $qti("0", "m/s")$ to $qti("300", "m/s")$. Yoke length: $qti("140", "mm")$, yoke width: $qti("10", "mm")$.]
)



#pagebreak()
