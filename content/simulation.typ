#pagebreak()

#import "@preview/physica:0.9.6": *
#import "@preview/unify:0.7.1": *
#import "@preview/codedis:0.3.0": code

#let qti(value, unit) = qty(value, unit, per:"/")

= Simulation<chapter:simulation>
The Simulation for this thesis is conducted using two different softwares: Ansys Maxwell 2025 R2 (Ansys Inc., USA) and Ansys Mecha 2025 R2 (Ansys Inc., USA).

== Ansys Maxwell
Since Ansys Maxwell is designed for electromagnetic simulations, it is the most intuitive choice for our problem. In the following sections we will discuss the different steps to prepare the simulation and the different options available in Ansys Maxwell for each step.

=== Solver Type
There are several solver types available in Maxwell like _Magnetostatic_, _Electrostatic_, _Eddy Current_ and so on. The only relevant in our use case is the _Transient_ one, since it includes movement. \
For a transient solution Maxwell offers two formulation, the $vb(T)-Omega$ formulation and the $vb(A)-Phi$ formulation. But here is only with the $vb(T)-Omega$ formulation motion allowed by Maxwell's software. Therefore the $vb(A)-Phi$ formulation solver of Maxwell is not relevant for this study.\
The $vb(T)-Omega$ formulation is also the default option for the _Transient_ solver, where the order of the magnetic scalar potential $Omega$ is 2 and the order of the electric vector potential $vb(T)$ is 1 @ansys_3D_transient_solver.
Maxwell uses for motion problems a fixed coordinate system for the Maxwell's equations in the moving part aswell as in the stationary part of the model. That means that the motion term is completly eliminated so there is no $vb(v) times vb(B)$ term for the electric current. Instead in the stationary frame the magnetic field is changing, where now the third Maxwell equation @maxwell_E2 can be applied. A combination of third and forth Maxwell equation @maxwell_H2 aswell of Ohm's law @ohms_law results in following differential equation:
$ curl 1/sigma curl vb(H) + pdv(vb(B),t) = 0 $
Togheter with Maxwell's second equation @maxwell_B1 this set of two equations yields the physical description of the problem.
=== Meshing
There are different types of meshing in Ansys to apply to a solid. At first, it makes automatically an initial mesh, which is then refined by the user in certain regions. \
For the initial mesh the methods are @ansys_maxwell_initialmeshsettings:
- Auto (default): automatically selects the mesher, mostly TAU
- Tau: well suited for curved surfaces
- (advanced) Tau Flex Meshing: may reduce meshing time, provides a mesh even for complex geometries
- Classic: uses the Bowyer algorithm. Well suited for geometries with many thin surfaces
- PhiPlus: efficient meshes for designs with layout components
In this thesis, the Auto method is used for the initial meshing. \
In a second step, the mesh is refined in the regions of interest. There are also different methods available for mesh refinement:
- length-based mesh inside an object: applies a mesh inside the whole object which a density specified by the _maximum_length_ parameter
- length-based mesh on object face: applies a mesh on the surface of an object which gets coarser with distance from the surface. Its density is specified by the _maximum_length_ parameter
- skin depth-based mesh on object face: applies a mesh on the surface of an object which is well suited for skin effects like eddy currents. The density on the surface plane is specified by the _triangulation_max_length_, whereas it's depth into the object is specified by the _skin_depth_ parameter and the corresponding density with the _layers_number_ parameter
Maxwell does also automatically adapt the vicinity of fine meshed areas.



=== Motion
<section:Motion>
Maxwell 3D's _Transient_ solution type offers the option to add motion to an object. This is done by defining a motion band, which is box wrapped around the object that should move. It is important to note that there is only one object allowed inside the motion band. If your object consists of several parts, e.g. a yoke and coil which should move togheter, you must wrap them inside a inner band which is then moving inside the motion band.\
Unfortunately, there is a catch with the mesh of the moving band: in contrast to other objects, which can have different mesh densitys (e.g. only dense mesh at one surface), Ansys applys always the highest density of the motion band to the whole band as a length-based mesh inside an object. I.e. when we have only a small region of interest, like the airgap between magnet and rail, where we need a high density mesh, this high density mesh is not only applied the the region of the moving band which is in the airgap but to the whole moving band. That increases computational costs dramatically.\
There a basicly two options to conduct the motion, either to move the magnet (yoke and coil) under the rail or the keep the magnet stationary and move the rail. Latter needs a longer moving band in x-direction (moving direction), but can be build much smaller in z-direction, because the eddy currents occur mainly on the surface which allows us to make a very thin rail. So with a moving rail the moving bands volume is significantly smaller which reduces computation time and is therefore choosen in this study.\
Another option is to build Yamamura's alternavtive model @fig:yamamura_simplified. This allows even a smaller moving band volume since the rail is condsiderably smaller in y-direction.



=== Yamamura Model on Ansys Maxwell
As discussed in @section:Motion the computational cost for the Yamamura model is significantly lower than that of the  conventional model, since the rail and thus the moving band can have condsiderably smaller volumes. This is why the model is recreated in Ansys Maxwell as shown in @yamamura_recreated.
#figure(
  image("../figures/simulation/yamamura_y10.png", width: 100%),
  caption: [Depiction of the yamura model recreated in Ansys Maxwell.]
)<yamamura_recreated>
The dimensions  of the yoke and the rail are given in $unit("mm")$ in the following table:
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
  table.cell(rowspan: 1)[*airgap*],
  [air_z], [1],
),
caption:[Geometry of the yoke and the rail in the Yamamura model. The dimensions are given in $unit("mm")$.]
)<table:yam_v100_mx>
\
*Simulation preparation*\
There are several steps to prepare the simulation:
1. Create the geometry of the different components like rail, yoke, coil and an airgap.
2. Assign current to the coils and turn on eddy effects for the rail.
3. Assign motion to the rail.
4. Create a setup which defines the parameter for the simulation.
5. Analyze the simulation setup

In a first simulation, we create the geometry in the dimensions described above and assign a velocity to the rail of $qti("100000", "mm/s")$ which is $qti("100", "m/s")$.
Since the mesh density is about $qti("1", "mm")$ and the velocity is $qti("100", "m/s")$, a time step of $qti("1e-5", "s")$ is choosen.
Former tests have shown that after around 20-30 time steps a steady state is reached so that the eddy currents are stable. To get more confident about this we chose in this run 90 time steps.\
#figure(
  image("../figures/simulation/eddy_currents_long.png", width: 100%),
  caption: [Depiction of the eddy currents in the Yamamura model at speed of $qti("100", "m/s")$. The rail is moving from left to right. Top view.]
)<eddy_currents_long>
In @eddy_currents_long we can see the eddy currents in the rail. They are basicaly only at the nose and tail of the magnet. In our frame the electrons move at positive x direction and the mangetic field points inside the plane, so they get diverted inside the magnet area to negative y direction. Outside the magnet area the electrons move back to the positive y edge of the rail due to the electric fields created by the charge displacement. This leads to a closed current loop which is here clockwise at the nose and counter-clockwise at the tail of the magnet.\
#figure(
  image("../figures/simulation/yam_long_force_x.svg", width: 100%),
  caption: [Breaking force of the Yamamura model at speed of $qti("100", "m/s")$ over time to observe the steady state.]
)<yam_long_force_x>
The braking force over time is depicted in @yam_long_force_x. Since we deal here with a transient simulation, the force is not constant but changes over time to find its equilibrium. We can see that after around $qty("500", "us")$ (50 time steps) the force is stable, which confirms that we reached our equilibrium with the 90 time steps. The breaking force is around $qty("400", "mN")$ and has negative values because it points against the direction of motion.\
We can put in the geometry parameters of the simulation to the Yamamura model which yields a breaking force of around $qty("3.83", "N")$ which is one magnitude larger than the one obtained in the simulation.

Since in the Yamamura geometry the yoke surfaces embrace the rail on both sides, the magnetic forces on the rail (or the magnet) in z-direction, which correspond to the lift force, cancel each other out, so that it is pointless to look at the lift force in this model. To study the lift force, we will look at the conventional model in the following sections.

#figure(
  image("../figures/simulation/B_profile_yam_mx_v100.svg", width: 100%),
  caption: [Magnetic field profile of the Yamamura model at speed of $qti("0", "m/s")$ (at $t=0$) and $qti("100", "m/s")$ (at $t=qti("0","s")$).]
)<B_profile_yam_long>
In @B_profile_yam_long we can see the magnetic field profile in the airgap at zero speed and at $qti("100", "m/s")$. We can see that at the nose of the magnet the magnetic field is reduced due to the induced field which points against the applied field, whereas at the tail of the magnet the magnetic field is increased due to the induced field which points in the same direction as the applied field. We can identify different regions, where we can describe a characteristic behavior of the magnetic field: at the nose region we see the highest drop of the magnetic field, which starts at $6.3 %$ (at $x=qty("-6.7","cm")$) and then decreases to around $3.1%$ (at $x=qty("-4.5","cm")$). In the middle region the magnetic field comes slowly back to the undisturbed value which it reaches at around $x=qty("3","cm")$. At the tail region the magnetic field is increased and reaches its maximum peak at around $x=qty("6.75","cm")$ which is the very end of the magnet. Here the magnetic field increases up to $5.8%$ compared to the zero speed case.\
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
  caption: [Comparision between the magnetic field profile of the Yamamura model simulated with Ansys Maxwell (a) and Ansys Mechanical (b) at speed of $qti("100", "m/s")$.]
)<B_profile_yam_mx_analy_comparison>
We can also compare the magnetic field profile at $qti("100", "m/s")$ to the one obtained with the analytical model of Yamamura. The profiles show a different form, whereas the simulation has a drop of magnetic field at the nose and a peak at the tail, the Yamamura model shows a complete shift of the magnetic field profile in x-direction towards the tail.



== Simualtion with Ansys Mechanical
The simulation with the Ansys Maxwell software is very inefficient for several reasons. The main reason is that with Ansys Maxwell we can only conduct a transient setup for our problem, even if we are interested only in a steady state solution. This requires on one hand a more complex solution, but also a larger geometry for the rail. Since the fine mesh must be distributed over the whole rail volume by Ansys Maxwell restrictions, this leads to a very inefficient use of fine mesh as described in @section:Motion. Ansys Maxwell is also not optimzed for parallel computing, so all of the calculatins run on one thread. This leads to very long computation time, namely around three weeks for a model with geometries as described in @table:yam_v100_mx. Therefore a diffrent approach is tested with Ansys Maxwell software and an unconvential solver type for this problem, namely a steady-state thermal solver.

=== Description of the setup
The whole setup is embedded in the Ansys Workbench software, where the geometry is created in Ansys Discovery and then imported to Ansys Mechanical.
==== Geometry
#let geo_code = read("../code/yamamura_geo.py")
The setup is built with Ansys Discovery Software via PyAnsys Geometry. There are five bodies created in the model, the rail, the yoke, the coil, the (fine meshed) airgap and a region box surrounding the whole model.
The airgap body is actually not the whole airgap between rail and yoke but only a small stripe in it, along which we want to observe the magnetic field with high resolution.
Here one has to be aware to not overlap the different bodies, this is done e.g. by cutting out the bodies from the region.
#code(geo_code, lines:(182,182), line-numbers:false)
\
For a succesfull meshing, all bodies must be combined using a shared topology.
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
Since we are using a Steady-State Thermal solver, we need to assign an arbitrary value for _Isotropic Thermal Conductivity_ to each material. This value is absolutly irrelevant for the solution, but is need for the Ansys solver to start the Simulation.
==== Meshing
All components except the region box get a finer mesh. The coil and the yoke body are assigned with a _Body Mesh Sizing_ of $qty("1.5", "mm")$. Additionaly the yoke is assigned with a _Patch Conforming Method_ that demands a mesh of _Tetrahedrons_ instead of _Hexahedrons_ which is the default for the other bodies.
The airgap body is assigned with a _Body Mesh Sizing_ of $qty("0.1", "mm")$ to ensure a high resolution of the magnetic field in this region.
For the rail we apply three mesh sizing methods along the edges: Along the x-edge we assing a _Edge Mesh Sizing_ of $qty("0.4", "mm")$, along the y-edge we assign a _Edge Mesh Sizing_ of $qty("0.5", "mm")$ and along the z-edge we assign a _Edge Mesh Sizing_ of $qty("0.1", "mm")$, the latter both with a bias that makes the mesh finer on the surfaces and coarser in the middle of the rail.

==== Additional preparations
To apply a current on the coil, we need to define a _Element Orientation_ with the y-coordinate along the current direction.\
It is often convienient and for the _APDL_ script necessary to define a _Named Selection_ for bodies, surfaces and edges where we want to assign on a velocity, a current, a mesh or an _Element Orientation_.\

==== _APDL_ script
#let apdl_code = read("../code/apdl.script.txt")
In the Ansys Mechanical software, we can write an _APDL_ script to define the physics of the problem. Since we have a steady-state thermal solver (because there is not an equivilant solver for electromagnetic problems) we need now to convert thermal elements to electromagnetic elements. Using arguments we can also easily apply a velocity to the rail and a current to the coil. The script is shown in the following:
#code(apdl_code, lang: "apdl", lines:(13,66), line-numbers:false)

=== Yamamura Model on Ansys Mechanical
In a first step we can look at the eddy currents in the rail. In @ec_yam_mc_y10 we can see that they are basicaly only at the nose and tail of the magnet. In our frame the electrons move at positive x direction and the mangetic field points inside the plane, so they get diverted inside the magnet area to negative y direction (positive current density $vb(J)$ points in the opposite direction, i.e. in positive y direction). We notice that the currents are not perfectly symmetric but highest at the rail edges and quenched in x-direction.
#figure(
  image("../figures/simulation/yam_ec.png", width: 100%),
  caption: [Depiction of the eddy currents in the Yamamura model at speed of $qti("100", "m/s")$ simulated with Ansys Mechanical. The rail is moving from left to right. Top view.]
)<ec_yam_mc_y10>

For retrieving the magnetic field in the airgap we define a surface parallel to the rail in the airgap. On this surface we can then export the magnetic field values and evaluate them.
Since the surface includes all values of the plane through the whole region, we need to cut at first at x and y coordinates to get the values inside the airgap.\
We can illustrate the result in a 2D color plot which is depicted for zero speed in @B_2Dprofile_yam_mc_y10 . As expected, the magnetic field is equally distributed in the airgap cross section at zero speed.


#figure(
  image("../figures/simulation/ColorMapB_2Dprofile_yam_mc_v0.png", width: 100%),
  caption: [Magnetic field 2D airgap profile of the Yamamura model at zero speed.]
)<B_2Dprofile_yam_mc_y10>

#figure(
  image("../figures/simulation/ColorMapdeltaB_2Dprofile_yam_mc_v100.png", width: 100%),
  caption: [Induced magnetic field 2D airgap profile of the Yamamura model at speed of $qti("100","m/s")$.]
)<DeltaB_2Dprofile_yam_mc_y10>

For higher velocities we choose not to plot the absolute value of the magnetic field but the change of the magnetic field compared to the zero speed case, which corresponds to the induced part of the magnetic field. In @DeltaB_2Dprofile_yam_mc_y10 we can see that at the nose we have a large reduction of the magnetic field of around $qty("30", "mT")$ and at the tail we have an increase of around $qty("20", "mT")$.
The value of the induced field also depends on the y coordinate, here we observe that they are highest at the middle of the rail and vanish towards the edges. This agrees with our previous considerations in @chapter:general_considerations.

To get more insight into the magnitude of the induced currents and their spacial distribution along the x-axis, we can plot the magnetic field along the x-axis in the airgap. A simulation with the same geometries and velocities as in @B_profile_yam_long is depicted in @B_profile_yam_mc_y10.
#figure(
  image("../figures/simulation/B_profile_yam_mc.svg", width: 100%),
  caption: [Magnetic field profile of the Yamamura model along the x-axis in the airgap at velocity $v=qti("100", "m/s")$. Simulated with Ansys Mechanical. Yoke length: $qti("135", "mm")$, yoke width: $qti("10", "mm")$]
)<B_profile_yam_mc_y10>
We can observe that with a rail width of $qty("10", "mm")$ the relative magnetic flux change is quite moderate with a lowest nose dip (LND) of 4.68% at the front and a highest tail peak (HTP) of 2.99% at the end of the magnet at a speed of $qti("100", "m/s")$. These values are characteristic for the B-profile and depend on the velocity as well as on the geometry of the rail and the yoke (which we will see later). To visualize the change of the magnetic field more clearly, we can plot the change of the magnetic field compared to the zero speed case, which is shown in @deltaB_profile_yam_mc.

#figure(
  image("../figures/simulation/deltaB_profile_yam_mc.svg", width: 100%),
  caption: [Change of magnetic field profile of the Yamamura model along the x-axis in the airgap at $v=qti("100", "m/s")$. Simulated with Ansys Mechanical. Yoke length: $qti("135", "mm")$, yoke width: $qti("10", "mm")$ ]
)<deltaB_profile_yam_mc>


== Comparision Ansys Maxwell and Ansys Mechanical
To verify the results of the Ansys Mechanical simulation, we can compare the magnetic field profile in the airgap to the one obtained with Ansys Maxwell. The comparison is shown in @B_profile_yam_y10_comparison. We can see the same behavior in both simulations: at the nose the induced field points against the applied field which leads to a reduction of the magnetic field, whereas at the tail the induced field points in the same direction as the applied field which leads to an increase of the magnetic field.

#figure(
  grid(columns:2, column-gutter: 1em, row-gutter: 0.5em,
  [#image("../figures/simulation/B_profile_yam_mx_small.svg", width: 100%)],
  [#image("../figures/simulation/B_profile_yam_mc_small.svg", width: 100%)],
  [(a)],[(b)],
  ),
  caption: [Comparision between the magnetic field profile of the Yamamura model simulated with Ansys Maxwell (a) and Ansys Mechanical (b) at speed of $qti("100", "m/s")$. Yoke length: $qti("135", "mm")$, yoke width: $qti("10", "mm")$]
)<B_profile_yam_y10_comparison>

To get a better insight into the differences between the two simulations, we can also compare the change of the magnetic field which is shown in @deltaB_profile_yam_y10_comparison.

#figure(
  grid(columns:2, column-gutter: 1em, row-gutter: 0.5em,
  [#image("../figures/simulation/deltaB_profile_yam_mx_small.svg", width: 100%)],
  [#image("../figures/simulation/deltaB_profile_yam_mc_small.svg", width: 100%)],
  [(a)],[(b)],
  ),
  caption: [Comparision between the change of magnetic field profile of the Yamamura model simulated with Ansys Maxwell (a) and Ansys Mechanical (b) at speed of $qti("100", "m/s")$. Yoke length: $qti("135", "mm")$, yoke width: $qti("10", "mm")$]
)<deltaB_profile_yam_y10_comparison>

The values of the change in the magnetic field are in the same order of magnitude, with a LND of 4.68% in Ansys Mechanical and 6.50% in Ansys Maxwell and a HTP of 2.99% in Ansys Mechanical and 5.41% in Ansys Maxwell at a speed of $qti("100", "m/s")$. The differences can be explained by the different meshing and solver types used in both simulations.\
We can also compare the resulting braking force. For the Maxwell simulation we can see that the transient plot in @yam_long_force_x converges to a braking force of around $qty("400", "mN")$ at $qti("100", "m/s")$, whereas the Ansys Mechanical simulation yields a braking force of around $qty("340", "mN")$ at the same speed (@Forces_yam_x135y10).\
#figure(
  image("../figures/simulation/F_yam_vsweep.svg", width: 100%),
  caption:[Breaking force of the Yamamura model at speeds from $qti("0", "m/s")$ to $qti("300", "m/s")$ simulated with Ansys Mechanical. Yoke length: $qti("135", "mm")$, yoke width: $qti("10", "mm")$.]
)<Forces_yam_x135y10>

In @DeltaB_2Dprofile_yam_mc_y10 we can see, that the resolution of the Mechanical simulation is much higher than the one of the Maxwell simulation, which can be explined by the higher mesh density at crucial areas. Therefore the Mechanical simulation is more trustworthy and will be used for the following simulations.



== Yamamura Model
As the simulation with Ansys Mechanical turned out to be way more efficient than the one with Ansys Maxwell, we will now use it to investigate different parameters of the Yamamura model. At first we will look at the velocity dependency of the model, then we will investigate the influence of the rail/yoke width and finally we will look at the influence of the yoke length.
Unless stated otherwise, following parameters will be used:
- velocity: $qti("100", "m/s")$
- yoke/rail width: $qti("10", "mm")$
- yoke length: $qti("140", "mm")$

=== Velocity dependency
For the velocity dependency we run the simulation for several velocities from $qti("0", "m/s")$ to $qti("300", "m/s")$. The resulting induced field profiles along the x-axis in the airgap are shown in @deltaB_profile_yam_mc_vsweep for representative velocities.
#figure(
  image("../figures/simulation/deltaB_profile_yam_mc_vsweep.svg", width: 100%),
  caption:[Change in magnetic field profile of the Yamamura model along the x-axis in the airgap at different velocities. Simulated with Ansys Mechanical. Yoke length: $qti("140", "mm")$, yoke width: $qti("10", "mm")$.]
)<deltaB_profile_yam_mc_vsweep>
We see that with increasing velocity the induced field becomes stronger, which is expected since the eddy currents are stronger at higher velocities. The amplitudes of the nose dip aswell as of the tail peak increase with increasing velocity. We observe along the length of the magnet a rest induced field which vanishes slowly towards the end of the magnet, which also grows with increasing velocity. The values of the lowest nose dips and highest tail peaks for all velocities are given in @table:LND_HTP_yam_mc_y10.
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
caption: [LND and HTP for several velocities in the Yamamura model with a rail width of $qty("10", "mm")$ and an applied magnetic field of $B_0=qty("1000", "mT")$. The values are obtained from the magnetic field profile along the x-axis in the airgap at different velocities.]
)<table:LND_HTP_yam_mc_y10>

#figure(
  image("../figures/simulation/F_yam_vfit.svg", width: 100%),
  caption:[Fit of the breaking force of the Yamamura model at speeds from $qti("0", "m/s")$ to $qti("300", "m/s")$ for different yoke widths $num("10"), num("15"), num("20"),num("25"),num("30") "and" qti("35", "mm")$. Yoke length: $qti("140", "mm")$. The red dots represent the simulated values, whereas the blue lines represent the fit with the function $F(v)=a v^b$.]
)<F_yam_vfit>
We can also look at the breaking force of the model at different velocities, which is shown in @F_yam_vfit, where the braking force is plotted against the velocity for several yoke widths. We can see that with increasing velocity the breaking force increases as well, which is expected since the eddy currents are stronger at higher velocities. The shape of the curve is similar to a square root function, therefore we fit the curves with a model function of the form $F(v)=a v^b$. The fitted curves are shown in @F_yam_vfit as blue lines, where the red dots represent the simulated values. The fit is very good with $R^2$ values above 0.99 for all velocities, the fitting parameters are shown in @table:F_yam_vfit_parameters.
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
  caption: [Fitted parameters for the breaking force of the Yamamura model at different velocities. The fitting is done with the function $F(v)=a v^b$.]
)<table:F_yam_vfit_parameters>
Indeed we see for the exponent $b$ that it is converging towards 0.5 with increasing yoke width, which confirms the square root shape of the curve. The prefactor $a$ is increasing with increasing yoke width, which is expected since a wider yoke leads to stronger eddy currents and thus a stronger braking force.


=== Yoke width dependency
For the yoke width dependency we run the simulation for several yoke widths from $qti("10", "mm")$ to $qti("35", "mm")$. The resulting induced field profiles along the x-axis in the airgap are shown in @deltaB_yam_ysweep for representative yoke widths.
#figure(
  image("../figures/simulation/deltaB_yam_ysweep.svg", width: 100%),
  caption:[Change in magnetic field profile of the Yamamura model at speed of $qti("100", "m/s")$ for different yoke widths. Yoke length: $qti("140", "mm")$.]
)<deltaB_yam_ysweep>
We observe a similar behavior for increasing yoke width as for increasing velocity, that the induced field becomes stronger, which is expected since the eddy currents can flow in larger circulations and thus get stronger at higher yoke widths. But in contrast to the velocity dependency, the shape of the curve does not only have increased amplitudes but also relaxes after the lowest nose dip way slower towards the end of the magnet. This corresponds also to a larger eddy current circulation flux, which has increased diameter in y-direction and in x-direction. The lift and drag forces are now not only affected by the nose and tail regions but also by the middle region of the magnet, which leads to a stronger braking force. The values of the lowest nose dips and highest tail peaks for all yoke widths are given in @table:LND_HTP_yam_ysweep.

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
caption: [LND and HTP for several yoke widths in the Yamamura model with a velocity of $qty("100", "m/s")$ and an applied magnetic field of $B_0=qty("1000", "mT")$.]
)<table:LND_HTP_yam_ysweep>

The yoke width dependeny of the breaking force is shown in @F_yam_yfit, where the braking force is plotted against the yoke width for several velocities. We can see that with increasing yoke width the breaking force increases as well, but with a much higher dependcy than for the velocity. The shape of the curve is similar to a square function therefore we fit the curves again with a model function of the form $F(x)=a x^b$. The fitted curves are shown in @F_yam_yfit as blue lines, where the red dots represent the simulated values. The coeefficient of determination $R^2$ is above 0.999 for all velocities, which indicates a very good fit. The fitted parameters are shown in @table:F_yam_yfit_parameters. \
#figure(
  image("../figures/simulation/F_yam_yfit.svg", width: 100%),
  caption:[Fit of the breaking force of the Yamamura model at yoke width from $qty("10", "mm")$ to $qty("35", "mm")$ for different velocities $num("30"), num("60"), num("100"), num("200")" and "qti("300","m/s")$. Yoke length: $qti("140", "mm")$. The red dots represent the simulated values, whereas the blue lines represent the fit with the function $F(x)=a x^b$.]
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
  caption: [Fitted parameters for the breaking force of the Yamamura model at different velocities. The fitting is done with the function $F(v)=a v^b$.]
)<table:F_yam_yfit_parameters>
For high velecities the exponent $b$ is converging towards 2, which confirms the square shape of the curve. The prefactor $a$ is increasing with increasing velocity, which is expected since a higher velocity leads to stronger eddy currents and thus a stronger braking force.


=== Yoke lenght dependency
For the yoke length dependency we run the simulation for several yoke lengths from $qti("100", "mm")$ to $qti("900", "mm")$. The resulting induced field profiles along the x-axis in the airgap are shown in @deltaB_yam_xsweep for representative yoke lengths.
#figure(
  image("../figures/simulation/deltaB_yam_xsweep.svg", width: 100%),
  caption:[Change in magnetic field profile of the Yamamura model at speed of $qti("100", "m/s")$ for different yoke lengths. Yoke width: $qti("10", "mm")$.]
)<deltaB_yam_xsweep>
We observe that with increasing yoke length no significant change in the shape nor the amplitudes of the induced field profile occurs. This is expected since the eddy currents are mainly induced at the nose and tail of the magnet, so that a longer yoke does not lead to stronger eddy currents but only has a larger middle region where the magnetic field is barly affected.

In @F_yam_xsweep we can see that the breaking force in dependence of the yoke length for different velocities. As expected, we can observe that the breaking force aswell is not affected by the length of the yoke. Therefore we wont apply a fit to the curves since they are basically constant.

#figure(
  image("../figures/simulation/F_yam_xsweep.svg", width: 100%),
  caption:[Breaking force of the Yamamura model at speeds from $qti("0", "m/s")$ to $qti("300", "m/s")$ for different yoke lengths. Yoke width: $qti("10", "mm")$.]
)<F_yam_xsweep>


=== Braking force fit



#pagebreak()
== TUM Hyperloop Model
The original model of the TUM Hyperloop consists of a rail and an electromagnet whichs yoke is shaped like a u. Since both yoke surfaces are exposed to the same side of the rail, the rail needs to be wider than in the Yamamura model, which increases the amount of mesh elements and thus the computational cost significantly. But the Hyperloop model can be used for actual levitation, since now a netto magnetic force can act between rail and magnet in z-direction, whereas in the Yamamura model the forces in z-direction cancel each other out. Therefore we will also investigate the Hyperloop model with Ansys Mechanical to get a better insight into the influence of the different parameters on the magnetic field and the resulting forces.

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
  [airgap], [1],
)
The geometry in original dimensions has a yoke length of $qti("1350", "mm")$ (\~ 10x larger), and a yoke width of $qti("3.5", "mm")$ (\~ 3.5x larger), which results in a scaling factor of 35 for the magnetic area of the smaller model.
#pagebreak()
