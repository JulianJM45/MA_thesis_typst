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



/*
=== $vb(A)-Phi$ Formulation in Maxwell 3D (Transient)
For solid conductors Maxwell 3D uses potential as introduced in @A-phi_potential @ansys_A-phi:
- $vb(B)=curl vb(A)$
- $vb(E)=-grad phi - dv(vb(A),t)$
Then the material equations,
- $vb(B)=mu vb(H)$
- $vb(D)=epsilon vb(E)$
the continuity equation with $pdv(rho, t)=0$
- $div vb(J) = 0$
and Ohm's law with the fourth macroscopic Maxwell equation:
- $vb(J)=sigma vb(E)+dv(vb(D),t)$
- $curl vb(H)=vb(J)$.
Notice that the term $dv(vb(D),t)$ actually belongs to the Maxwell equation and not to Ohm's law, but this won't change the equation system in this case.
Inserting these equations into the fourth Maxwell equations evolves to:
- $curl 1/mu vb(B)=sigma vb(E)+dv(vb(D),t)$
- $curl 1/mu curl vb(A)=-sigma dv(vb(A),t) - sigma grad phi - dv(,t)(epsilon dv(vb(A),t))-dv(,t)(epsilon grad phi)$
In the documentation of Maxwell 3D it is stated, that the radiation term $dv(,t)(epsilon dv(vb(A),t)$ is ignored, since it is negligible in low-frequency simulations. This does only partially correlate to the statement in @displacement-current, where we showed that the whole displacement current $pdv(vb(D),t)$ term can be neglected.
Furthermore, a term for permanent magnets is added, with $vb(H)_c$ as the coercivity of the permanent magnet.\
\
In the same way the above equations are inserted into the second Maxwell equation. This leads two the following set of two equations which Maxwell 3D solves:
$ div (-sigma dv(vb(A),t) -sigma grad phi - dv(,t)(epsilon grad phi))=0 $
$ curl 1/mu curl vb(A)=-sigma dv(vb(A),t) - sigma grad phi -dv(,t)(epsilon grad phi) + curl vb(H)_c $

=== Comparison of T-Omega and A-Phi Solver
Following comparison table is taken from the Ansys Maxwell documentation @ansys_solver-comparison:


#figure(
  table(
    columns: (1fr, 1fr),
    align: (left, left),
    stroke: 0.5pt,
    inset: 8pt,

    table.header(
      [*T-Omega*],
      [*A-Phi*],
    ),

    [Solves second-order elements for magnetic B field],
    [Solves second-order F for electrical E field, and solves first-order A for magnetic B field. (In order to account the difference in the order of elements solved, increasing the mesh density in A-Phi should help achieve the same B field results as T-Omega.)],

    [Computational efficient for electric machines applications],
    [Computational efficient and flexible for ECAD PCB and electronics applications],

    [Does not support multi-terminals with mixed excitation types on the same conduction path],
    [Supports multi-terminals with mixed excitation types on the same conduction path],

    [Ignores displacement current],
    [Can consider capacitive effects (displacement current)],

    [Supports all advanced material modeling],
    [Limited advanced material modeling capabilities],

    [Easy handling of motion due to only scalar potential for the motion coupling],
    [Does not support motion],
  ),
  caption: [Comparison of T-Omega and A-Phi formulations]
)
*/
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
We can put in the geometry parameters of the simulation to the Yamamura model which yields a breaking force of around $qty("3.83", "N")$ which is one magnitude larger than the one obtained in the simulation.\
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


#pagebreak()
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
We can observe that with a rail width of $qty("10", "mm")$ the relative magnetic flux change is quite moderate with a  lowest nose dip (LND) of 4.68% at the front and a highest tail peak (HTP) of 2.99% at the end of the magnet at a speed of $qti("100", "m/s")$. These values are characteristic for the B-profile and depend on the velocity as well as on the geometry of the rail and the yoke (which we will see later). To visualize the change of the magnetic field more clearly, we can plot the change of the magnetic field compared to the zero speed case, which is shown in @deltaB_profile_yam_mc.

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
In @DeltaB_2Dprofile_yam_mc_y10 we can see, that the resolution of the Mechanical simulation is much higher than the one of the Maxwell simulation, which can be explined by the higher mesh density at crucial areas. Therefore the Mechanical simulation is more trustworthy and will be used for the following simulations.







#pagebreak()
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
We see that with increasing velocity the induced field becomes stronger, which is expected since the eddy currents are stronger at higher velocities. The amplitudes of the nose dip aswell as of the tail peak increase with increasing velocity. We observe along the length of the magnet a rest induced field which vanishes slowly towards the end of the magnet, which also grows with increasing velocity. The values of the LND and HTP for all velocities are given in @table:LND_HTP_yam_mc_y10.

#figure(
table(
  columns: (auto, auto, auto),
  align: horizon,
  table.header([*Velocity in $m/s$*], [*LND in mT (%)*], [*HTP in mT (%)*]),
  [30], [15.37 (2.49%)], [8.55 (1.39%)],
  [60], [21.94 (3.56%)], [13.02 (2.11%)],
  [100], [28.89 (4.68%)], [18.42 (2.99%)],
  [200], [43.60 (7.07%)], [31.45 (5.10%)],
  [300], [57.09 (9.25%)], [44.46 (7.21%)]
),
caption: [LND and HTP for several velocities in the Yamamura model with a rail width of $qty("10", "mm")$ and an applied magnetic field of $B_0=qty("617", "mT")$. The values are obtained from the magnetic field profile along the x-axis in the airgap at different velocities.]
)<table:LND_HTP_yam_mc_y10>

// #figure(
//   image("../figures/simulation/B_profile_yam_mc_vsweep.svg", width: 100%),
//   caption:[]
// )<B_profile_yam_mc_vsweep>

#figure(
  image("../figures/simulation/F_yam_vsweep.svg", width: 100%),
  caption:[Breaking force of the Yamamura model at speeds from $qti("0", "m/s")$ to $qti("300", "m/s")$ simulated with Ansys Mechanical. Yoke length: $qti("140", "mm")$, yoke width: $qti("10", "mm")$.]
)<Forces_yam_x135y10>
// #figure(
//   image("../figures/simulation/F_yam_x140y15.svg", width: 100%),
//   caption:[Breaking force of the Yamamura model at speeds from $qti("0", "m/s")$ to $qti("300", "m/s")$ simulated with Ansys Mechanical. Yoke length: $qti("140", "mm")$, yoke width: $qti("15", "mm")$.]
// )<F_yam_x140y15>


// #figure(
//   image("../figures/simulation/F_yam_x140y20.svg", width: 100%),
//   caption:[Breaking force of the Yamamura model at speeds from $qti("0", "m/s")$ to $qti("300", "m/s")$ simulated with Ansys Mechanical. Yoke length: $qti("140", "mm")$, yoke width: $qti("20", "mm")$.]
// )<F_yam_x140y20>

#pagebreak()
=== Rail width dependency
#figure(
  image("../figures/simulation/deltaB_yam_ysweep.svg", width: 100%),
  caption:[Change in magnetic field profile of the Yamamura model at speed of $qti("100", "m/s")$ for different yoke widths. Yoke length: $qti("140", "mm")$.]
)
hi
#figure(
  image("../figures/simulation/F_yam_ysweep.svg", width: 100%),
  caption:[Breaking force of the Yamamura model at speeds from $qti("0", "m/s")$ to $qti("300", "m/s")$ for different yoke widths. Yoke length: $qti("140", "mm")$.]
)<F_yam_ysweep>



=== Rail lenght dependency ?




#pagebreak()
== TUM Hyperloop Model
The basic setup of the 3D Simulation consists of two main components: the rail and the electromagnet which is made of a coil of wire wound around a ferromagnetic yoke.
The dimensions in $qty("1","mm")$ are given in the following table:

#table(
  columns: (auto, auto, auto),
  align: horizon,

  table.header([*Component*], [*Size*], [*Value*]),
  table.cell(rowspan: 3)[*yoke*],
  [yoke_x], [135],
  [yoke_y], [14.7],
  [yoke_z], [10],
  table.cell(rowspan: 2)[*coil*],
  [coil_thickness], [4.5],
  [coil_padding], [0.2],
)
