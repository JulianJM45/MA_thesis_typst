#pagebreak()

#import "@preview/physica:0.9.6": *


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


== Solver Type
There are several solver types available in Maxwell like _Magnetostatic_, _Electrostatic_, _Eddy Current_ and so on. The only relevant in our use case is the _Transient_ one, since it includes movement. \
For a transient solution Maxwell offers two formulation, the $vb(T)-omega$ formulation and the $vb(A)-Phi$ formulation.
=== $vb(T)-omega$
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

== Yamamura Model

== TUM Hyperloop Model
The basic setup of the 3D Simulation consists of two main components: the rail and the electromagnet which is made of a coil of wire wound around a ferromagnetic yoke.
The dimensions are given in the following table:

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
