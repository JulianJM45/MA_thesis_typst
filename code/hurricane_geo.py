# %%
from ansys.geometry.core import launch_modeler
from ansys.geometry.core.designer import SharedTopologyType
from ansys.geometry.core.math import Plane, Point2D, Point3D, Vector3D
from ansys.geometry.core.misc import DEFAULT_UNITS, UNITS
from ansys.geometry.core.sketch import Sketch

# %%
DEFAULT_UNITS.LENGTH = UNITS.cm
# Start a modeler session
modeler = launch_modeler(mode="discovery")
print(modeler)


# %% declare dimensions
rail_x = 250
rail_y = 17
rail_z = 3

airgap = 1

yoke_x = 135
yoke_y = 15
yoke_z = 10
yoke_width = 3.5

coil_thickness = 4
coil_padding = 0.2

region_padding = 20


# velocity = 100e3

# %% create design and component
design = modeler.create_design("Yamamura_design")
component = design.add_component(name="component")

# %% create rail, yoke, coil
rail_plane = Plane(
    Point3D([0, 0, airgap]),
)
sketch_rail = Sketch(rail_plane)
sketch_rail.box(Point2D([0, 0]), width=rail_x, height=rail_y)
rail = component.extrude_sketch(name="rail", sketch=sketch_rail, distance=rail_z)

yoke_plane = Plane(
    Point3D([-yoke_x / 2, 0, 0]),
    direction_x=Vector3D([0, 1, 0]),
    direction_y=Vector3D([0, 0, 1]),
)
sketch_yoke = Sketch(yoke_plane)
sketch_yoke.box(
    Point2D([0, -yoke_z / 2]),
    width=yoke_y,
    height=yoke_z,
)

sketch_yoke_cut = Sketch(yoke_plane)
sketch_yoke_cut.box(
    Point2D([0, (-yoke_z + yoke_width) / 2]),
    width=yoke_y - 2 * yoke_width,
    height=yoke_z - yoke_width,
)
yoke = component.extrude_sketch(name="yoke", sketch=sketch_yoke, distance=yoke_x)
yoke_cut = component.extrude_sketch(
    name="yoke_cut", sketch=sketch_yoke_cut, distance=yoke_x
)
yoke.subtract(yoke_cut)

yoke_edges_list = [0, 6, 11, 8]
for i in yoke_edges_list:
    modeler.geometry_commands.fillet(yoke.edges[i], radius=yoke_width / 2)

coil_plane = Plane(
    Point3D(
        [
            0,
            yoke_y / 2 - yoke_width - coil_padding,
            -yoke_z - coil_padding,
        ]
    ),
    direction_x=Vector3D([1, 0, 0]),
    direction_y=Vector3D([0, 0, 1]),
)
sketch_coil = Sketch(coil_plane)
(
    sketch_coil.segment(
        Point2D([(-yoke_x + yoke_width) / 2, 0]),
        Point2D([(yoke_x - yoke_width) / 2, 0]),
    )
    .arc_to_point(
        Point2D([(yoke_x - yoke_width) / 2, yoke_width + 2 * coil_padding]),
        center=Point2D([(yoke_x - yoke_width) / 2, yoke_width / 2 + coil_padding]),
    )
    .segment_to_point(
        Point2D([(-yoke_x + yoke_width) / 2, yoke_width + 2 * coil_padding])
    )
    .arc_to_point(
        Point2D([(-yoke_x + yoke_width) / 2, 0]),
        center=Point2D([(-yoke_x + yoke_width) / 2, yoke_width / 2 + coil_padding]),
    )
)

(
    sketch_coil.segment(
        Point2D([(-yoke_x + yoke_width) / 2, -coil_thickness]),
        Point2D([(yoke_x - yoke_width) / 2, -coil_thickness]),
    )
    .arc_to_point(
        Point2D(
            [
                (yoke_x - yoke_width) / 2,
                yoke_width + 2 * coil_padding + coil_thickness,
            ]
        ),
        center=Point2D([(yoke_x - yoke_width) / 2, yoke_width / 2 + coil_padding]),
    )
    .segment_to_point(
        Point2D(
            [
                (-yoke_x + yoke_width) / 2,
                yoke_width + 2 * coil_padding + coil_thickness,
            ]
        )
    )
    .arc_to_point(
        Point2D([(-yoke_x + yoke_width) / 2, -coil_thickness]),
        center=Point2D([(-yoke_x + yoke_width) / 2, yoke_width / 2 + coil_padding]),
    )
)

coil = component.extrude_sketch(
    name="coil",
    sketch=sketch_coil,
    distance=yoke_y - 2 * yoke_width - 2 * coil_padding,
)


region_plane = Plane(
    Point3D([0, 0, -yoke_z / 2 - region_padding]),
)
sketch_region = Sketch(region_plane)
sketch_region.box(
    Point2D([0, 0]),
    width=rail_x + 2 * region_padding,
    height=2 * yoke_y + 2 * region_padding,
)
region = component.extrude_sketch(
    name="region", sketch=sketch_region, distance=yoke_z + 2 * region_padding
)
region.subtract([rail, yoke, coil], keep_other=True)

component.set_shared_topology(share_type=SharedTopologyType.SHARETYPE_SHARE)


# %%
modeler.close()
