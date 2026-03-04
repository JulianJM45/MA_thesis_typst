# %%
import os
from pathlib import Path

from ansys.geometry.core import launch_modeler
from ansys.geometry.core.designer import DesignFileFormat, SharedTopologyType
from ansys.geometry.core.math import Plane, Point2D, Point3D, Vector3D
from ansys.geometry.core.misc import DEFAULT_UNITS, UNITS
from ansys.geometry.core.sketch import Sketch

# from django.template.defaultfilters import center

# %%
DEFAULT_UNITS.LENGTH = UNITS.mm
# Start a modeler session
modeler = launch_modeler(mode="discovery")
print(modeler)


# %% declare dimensions
rail_x = 245
rail_y = 10
rail_z = 1

airgap = 1

yoke_x = 135
yoke_y = 10
yoke_z = 15
yoke_thickness = 3.5

coil_thickness = 2.5
coil_padding = 0.2

region_padding = 20


# velocity = 100e3

# %% create design and component
design = modeler.create_design("Yamamura_design")
component = design.add_component(name="component")

# %%

coil_plane = Plane(
    Point3D(
        [
            0,
            -rail_y / 2 - 2 * coil_thickness - yoke_thickness / 2,
            -yoke_z / 2 + yoke_thickness + coil_padding,
        ]
    )
)
sketch_coil = Sketch(coil_plane)
(
    sketch_coil.segment(
        Point2D([-yoke_x / 2 - coil_padding, -yoke_thickness / 2 - coil_padding]),
        Point2D([yoke_x / 2 + coil_padding, -yoke_thickness / 2 - coil_padding]),
    )
    .arc_to_point(
        Point2D([yoke_x / 2 + coil_padding, yoke_thickness / 2 + coil_padding]),
        center=Point2D([yoke_x / 2 + coil_padding, 0]),
    )
    .segment_to_point(
        Point2D([-yoke_x / 2 - coil_padding, yoke_thickness / 2 + coil_padding])
    )
    .arc_to_point(
        Point2D([-yoke_x / 2 - coil_padding, -yoke_thickness / 2 - coil_padding]),
        center=Point2D([-yoke_x / 2 - coil_padding, 0]),
    )
)

(
    sketch_coil.segment(
        Point2D(
            [
                -yoke_x / 2 - coil_padding,
                -yoke_thickness / 2 - coil_padding - coil_thickness,
            ]
        ),
        Point2D(
            [
                yoke_x / 2 + coil_padding,
                -yoke_thickness / 2 - coil_padding - coil_thickness,
            ]
        ),
    )
    .arc_to_point(
        Point2D(
            [
                yoke_x / 2 + coil_padding,
                yoke_thickness / 2 + coil_padding + coil_thickness,
            ]
        ),
        center=Point2D([yoke_x / 2 + coil_padding, 0]),
    )
    .segment_to_point(
        Point2D(
            [
                -yoke_x / 2 - coil_padding,
                yoke_thickness / 2 + coil_padding + coil_thickness,
            ]
        )
    )
    .arc_to_point(
        Point2D(
            [
                -yoke_x / 2 - coil_padding,
                -yoke_thickness / 2 - coil_padding - coil_thickness,
            ]
        ),
        center=Point2D([-yoke_x / 2 - coil_padding, 0]),
    )
)

# sketch_coil.box(
#     Point2D([0, 0]),
#     width=yoke_x + 2 * coil_padding + 2 * coil_thickness,
#     height=yoke_thickness + 2 * coil_padding + 2 * coil_thickness,
# )
# sketch_coil.box(
#     Point2D([0, 0]),
#     width=yoke_x + 2 * coil_padding,
#     height=yoke_thickness + 2 * coil_padding,
# )
coil = component.extrude_sketch(
    name="coil",
    sketch=sketch_coil,
    distance=yoke_z - 2 * yoke_thickness - 2 * coil_padding,
)


# %% create rail, yoke, coil
rail_plane = Plane(
    Point3D([0, 0, -rail_z / 2]),
)
sketch_rail = Sketch(rail_plane)
sketch_rail.box(Point2D([0, 0]), width=rail_x, height=rail_y)
rail = component.extrude_sketch(name="rail", sketch=sketch_rail, distance=rail_z)

# %%

yoke_plane = Plane(
    Point3D([-yoke_x / 2, 0, 0]),
    direction_x=Vector3D([0, 1, 0]),
    direction_y=Vector3D([0, 0, 1]),
)
sketch_yoke = Sketch(yoke_plane)
(
    sketch_yoke.box(
        Point2D([-yoke_thickness / 2 - coil_thickness, 0]),
        width=yoke_thickness + 2 * coil_thickness + rail_y,
        height=yoke_z,
    ).box(
        Point2D([-rail_y / 2 - coil_thickness, 0]),
        width=2 * coil_thickness,
        height=yoke_z - 2 * yoke_thickness,
    )
)
sketch_yoke_cut = Sketch(yoke_plane)
sketch_yoke_cut.box(Point2D([0, 0]), width=yoke_y, height=rail_z + 2 * airgap)
yoke = component.extrude_sketch(name="yoke", sketch=sketch_yoke, distance=yoke_x)
yoke_cut = component.extrude_sketch(
    name="yoke_cut", sketch=sketch_yoke_cut, distance=yoke_x
)
yoke.subtract(yoke_cut)


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

# %%
# coil_edges_list = [1, 2, 3, 4, 19, 18, 17, 16]
# for i in coil_edges_list:
#     modeler.geometry_commands.fillet(coil.edges[i], radius=1)

# %%
# yoke_edges_list = [4, 5, 10, 12, 13, 14, 1]
# # yoke_edges_list = [4, 5, 10, 12, 13, 14]
# for i in yoke_edges_list:
#     modeler.geometry_commands.fillet(yoke.edges[i], radius=1)
# # %%
# modeler.geometry_commands.fillet(yoke.edges[9], radius=1.5)

# %%
component.set_shared_topology(share_type=SharedTopologyType.SHARETYPE_SHARE)

# %%
file_dir = Path(os.getcwd(), "downloads")
file_dir.mkdir(parents=True, exist_ok=True)
print(file_dir)
# %%
design.download(
    file_location=Path(file_dir, "Yamamura.scdocx"), format=DesignFileFormat.SCDOCX
)
# %%
file = design.export_to_disco()
print(f"Design saved to {file}")

# %%
modeler.close()
