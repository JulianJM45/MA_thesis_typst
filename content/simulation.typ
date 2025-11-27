#pagebreak()

= Simulation

== 3D Simulation
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
