#pagebreak()

#import "@preview/physica:0.9.6": *
#import "@preview/unify:0.7.1": *

#let qti(value, unit) = qty(value, unit, per:"/")

= Simulation
The Simulation for this thesis is conducted using Ansys Maxwell 2025 R2 (Ansys Inc., USA) software.

== Meshing
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



== Motion
<section:Motion>
Maxwell 3D's _Transient_ solution type offers the option to add motion to an object. This is done by defining a motion band, which is box wrapped around the object that should move. It is important to note that there is only one object allowed inside the motion band. If your object consists of several parts, e.g. a yoke and coil which should move togheter, you must wrap them inside a inner band which is then moving inside the motion band.\
Unfortunately, there is a catch with the mesh of the moving band: in contrast to other objects, which can have different mesh densitys (e.g. only dense mesh at one surface), Ansys applys always the highest density of the motion band to the whole band as a length-based mesh inside an object. I.e. when we have only a small region of interest, like the airgap between magnet and rail, where we need a high density mesh, this high density mesh is not only applied the the region of the moving band which is in the airgap but to the whole moving band. That increases computational costs dramatically.\
There a basicly two options to conduct the motion, either to move the magnet (yoke and coil) under the rail or the keep the magnet stationary and move the rail. Latter needs a longer moving band in x-direction (moving direction), but can be build much smaller in z-direction, because the eddy currents occur mainly on the surface which allows us to make a very thin rail. So with a moving rail the moving bands volume is significantly smaller which reduces computation time and is therefore choosen in this study.\
Another option is to build Yamamura's alternavtive model @fig:yamamura_simplified. This allows even a smaller moving band volume since the rail is condsiderably smaller in y-direction.


== Solver Type
There are several solver types available in Maxwell like _Magnetostatic_, _Electrostatic_, _Eddy Current_ and so on. The only relevant in our use case is the _Transient_ one, since it includes movement. \
For a transient solution Maxwell offers two formulation, the $vb(T)-Omega$ formulation and the $vb(A)-Phi$ formulation. But here is only with the $vb(T)-Omega$ formulation motion allowed by Maxwell's software. Therefore the $vb(A)-Phi$ formulation solver of Maxwell is not relevant for this study.\
The $vb(T)-Omega$ formulation is also the default option for the _Transient_ solver, where the order of the magnetic scalar potential $Omega$ is 2 and the order of the electric vector potential $vb(T)$ is 1 @ansys_3D_transient_solver.
Maxwell uses for motion problems a fixed coordinate system for the Maxwell's equations in the moving part aswell as in the stationary part of the model. That means that the motion term is completly eliminated so there is no $vb(v) times vb(B)$ term for the electric current. Instead in the stationary frame the magnetic field is changing, where now the third Maxwell equation @maxwell_E2 can be applied. A combination of third and forth Maxwell equation @maxwell_H2 aswell of Ohm's law @ohms_law results in following differential equation:
$ curl 1/sigma curl vb(H) + pdv(vb(B),t) = 0 $
Togheter with Maxwell's second equation @maxwell_B1 this set of two equations yields the physical description of the problem.

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
== Yamamura Model
As discussed in @section:Motion the computational cost for the Yamamura model is significantly lower than that of the  conventional model, since the rail and thus the moving band can have condsiderably smaller volumes. This is why the model is recreated in Ansys Maxwell as shown in @yamamura_recreated.
#figure(
  image("../figures/simulation/yamamura_y10.png", width: 100%),
  caption: [Depiction of the yamura model recreated in Ansys Maxwell.]
)<yamamura_recreated>
The dimensions  of the yoke and the rail are given in $unit("mm")$ in the following table:
#table(
  columns: (auto, auto, auto),
  align: horizon,

  table.header([*Component*], [*Size*], [*Value*]),
  table.cell(rowspan: 3)[*yoke*],
  [yoke_x], [135],
  [yoke_y], [x],
  [yoke_z], [x],
  table.cell(rowspan: 3)[*rail*],
  [rail_x], [245],
  [rail_y], [10],
  [rail_z], [1]
)
\
*Simulation preparation*\
There are several steps to prepare the simulation:
1. Create the geometry of the different components like rail, yoke, coil and an airgap.
2. Assign current to the coils and turn on eddy effects for the rail.
3. Assign motion to the rail.
4. Create a setup which defines the parameter for the simulation.
5. Analyze the simulation setup

In a first simulation, we create the geometry in the dimensions described above and assign a velocity to the rail of $qti("100000", "mm/s")$ which is $qti("100", "m/s")$.

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
