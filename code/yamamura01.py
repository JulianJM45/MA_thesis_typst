# %% start the programm
import os
import tempfile
import time

import ansys.aedt.core

# %% setup
AEDT_VERSION = "2025.2"
NUM_CORES = 4
NG_MODE = False  # Open AEDT UI when it is launched.

# %% temp project
temp_folder = tempfile.TemporaryDirectory(suffix=".ansys")
print("Project will be created in %s" % temp_folder.name)

working_directory = "C:\\Users\\Aerodynamics\\Julian_Schueler_Ansys\\"

m3d = ansys.aedt.core.Maxwell3d(
    project=os.path.join(temp_folder.name, "yamamura01.aedt"),
    solution_type="Transient",
    version=AEDT_VERSION,
    non_graphical=NG_MODE,
    # new_desktop=True,
)
uom = m3d.modeler.model_units = "mm"

# %% declare dimensions
yoke_x = 135
yoke_y, yoke_z, yoke_thickness = 14.7, 10, 3.5

coil_thickness, coil_padding = 0.8 * yoke_z - yoke_thickness, 0.2
coil_thickness = 2.5
print("coil_thickness: ", coil_thickness)

rail_length = 245

rail_y, rail_z = yoke_thickness, yoke_z
rail_y = 10
rail_z = 1

# magnet_length = yoke_x + 2 * coil_thickness + 2 * coil_padding
magnet_length = yoke_x

region_pad = 10  # Padding around the model

band_length = 2 * rail_length - magnet_length
band_clearance, start_position, airgap = 0.1, 10, 1

velocity = 100e3
max_positive_limit = band_length - rail_length
print("Min Positive limit: ", start_position)
print("Max Positive limit: ", max_positive_limit)
print("velocity: ", velocity)
positive_limit = 100
travel_distance = positive_limit - start_position
print("Travel distance: ", travel_distance)

# %% create yoke
yoke = m3d.modeler.create_box(
    origin=[-yoke_x / 2, 0, 0],
    sizes=[
        yoke_x,
        rail_y + 2 * yoke_thickness,
        4 * yoke_thickness + rail_z + 2 * airgap,
    ],
    name="Yoke",
    material="iron",
)

yoke_cutout1 = m3d.modeler.create_box(
    origin=[-yoke_x / 2, 0, 2 * yoke_thickness],
    sizes=[yoke_x, rail_y, rail_z + 2 * airgap],
    name="Yoke_Cutout1",
)

yoke_cutout2 = m3d.modeler.create_box(
    origin=[-yoke_x / 2, rail_y, yoke_thickness],
    sizes=[yoke_x, yoke_thickness, rail_z + 2 * airgap + 2 * yoke_thickness],
    name="Yoke_Cutout2",
)

m3d.modeler.subtract(yoke, [yoke_cutout1, yoke_cutout2], keep_originals=False)

# %% create coil
coil = m3d.modeler.create_box(
    origin=[
        -yoke_x / 2 - coil_thickness - coil_padding,
        rail_y + yoke_thickness - coil_thickness - coil_padding,
        yoke_thickness + coil_padding,
    ],
    sizes=[
        2 * coil_thickness + 2 * coil_padding + yoke_x,
        2 * coil_thickness + 2 * coil_padding + yoke_thickness,
        rail_z + 2 * airgap + 2 * yoke_thickness - 2 * coil_padding,
    ],
    name="Coil",
    material="copper",
)

coil_cutout = m3d.modeler.create_box(
    origin=[
        -yoke_x / 2 - coil_padding,
        rail_y + yoke_thickness - coil_padding,
        yoke_thickness + coil_padding,
    ],
    sizes=[
        yoke_x + 2 * coil_padding,
        yoke_thickness + 2 * coil_padding,
        rail_z + 2 * airgap + 2 * yoke_thickness - 2 * coil_padding,
    ],
    name="Coil_Cutout",
)

m3d.modeler.subtract(coil, [coil_cutout], keep_originals=False)

section1 = m3d.modeler.section(assignment=coil, plane="YZ")

coil_termianl1 = coil.name + "_Section1"

m3d.modeler.separate_bodies(assignment=coil_termianl1)

m3d.modeler.delete(assignment=coil.name + "_Section1_Separate1")

# %% assign current
m3d.assign_winding(
    assignment=coil_termianl1,
    current=1e3,
    is_solid=False,
    name="Current_1",
)

# %% create rail
rail = m3d.modeler.create_box(
    origin=(yoke_x / 2 - rail_length, 0, 2 * yoke_thickness + airgap),
    sizes=(rail_length, rail_y, rail_z),
    name="Rail",
    material="iron",
)

# %% create region
region = m3d.modeler.create_box(
    origin=[yoke_x / 2 - rail_length - region_pad, -region_pad, -region_pad],
    sizes=[
        band_length + 2 * region_pad,
        rail_y + 2 * yoke_thickness + 2 * region_pad,
        4 * yoke_thickness + rail_z + 2 * airgap + 2 * region_pad,
    ],
    name="Region",
)

# %% create airgap
fine_airgap = m3d.modeler.create_box(
    origin=[-yoke_x / 2, 0, 2 * yoke_thickness],
    sizes=[yoke_x, rail_y, airgap - band_clearance],
    name="Fine_Airgap",
)

fine_airgap2 = m3d.modeler.create_box(
    origin=[-yoke_x / 2, 0, 2 * yoke_thickness + airgap + rail_z + band_clearance],
    sizes=[yoke_x, rail_y, airgap - band_clearance],
    name="Fine_Airgap2",
)

# %% create lines
line_count = 7

if line_count < 2:
    line_points = [
        [-yoke_x, rail_y / 2, 2 * yoke_thickness + airgap / 2],
        [yoke_x, rail_y / 2, 2 * yoke_thickness + airgap / 2],
    ]
    m3d.modeler.create_polyline(points=line_points, name="Line1")
else:
    delta_y = rail_y / (line_count - 1)
    for i in range(line_count):
        line_points = [
            [-yoke_x, i * delta_y, 2 * yoke_thickness + airgap / 2],
            [yoke_x, i * delta_y, 2 * yoke_thickness + airgap / 2],
        ]
        m3d.modeler.create_polyline(points=line_points, name=f"Line{i + 1}")

m3d.modeler.fit_all()

# %% assign motion
band_id = m3d.modeler.create_box(
    origin=[
        +yoke_x / 2 - rail_length - band_clearance,
        -band_clearance,
        2 * yoke_thickness + airgap - band_clearance,
    ],
    sizes=[
        band_length + 2 * band_clearance,
        rail_y + 2 * band_clearance,
        rail_z + 2 * band_clearance,
    ],
    name="Motion_Band",
)

m3d.assign_translate_motion(
    assignment=band_id,
    axis="X",
    start_position=start_position,
    periodic_translate=False,
    # negative_limit=-1,
    positive_limit=positive_limit,
    velocity=f"{velocity}{uom}_per_sec",
)

# %% apply mesh operations
m3d.mesh.assign_length_mesh(
    assignment=[fine_airgap, fine_airgap2],
    inside_selection=True,
    maximum_elements=None,
    maximum_length="0.5mm",
    name="Fine_Airgap_Mesh",
)

m3d.mesh.assign_skin_depth(
    assignment=[
        m3d.modeler.get_object_faces("Rail")[0],
        m3d.modeler.get_object_faces("Rail")[4],
    ],  # Use the bottom face of the rail
    # skin_depth="0.2mm",
    triangulation_max_length="0.4mm",
    layers_number=4,
    name="Rail_Surface_Mesh",
)

# %% turn on eddy effects
m3d.eddy_effects_on(assignment=["Rail"])

# %% set up simulation
stop_time = (
    travel_distance
) / velocity  # Time to cover the band length at the given velocity
time_accuracy = 1e-5

if time_accuracy > stop_time:  # to avoid having time step larger than stop time
    time_accuracy = stop_time

setup = m3d.create_setup("Setup1")
setup.props["StopTime"] = f"{stop_time}s"
# setup.props["TimeStep"] = f"{stop_time/10}s"
setup.props["TimeStep"] = f"{time_accuracy}s"

setup.props["SaveFieldsType"] = "Every N Steps"
setup.props["N Steps"] = 2
setup.props["Steps To"] = f"{stop_time}s"

setup.props["NonlinearSolverResidual"] = 1e-5

setup.update()

print(
    f"Stop time: {stop_time}s, Time step: {time_accuracy}, steps={int(stop_time / (time_accuracy))}"
)

# %% analyze
m3d.analyze_setup("Setup1")

# %% save project
m3d.save_project(
    file_name=r"C:\Users\Aerodynamics\Julian_Schueler_Ansys\yamamura_y10_long.aedt",
    overwrite=True,
)

# %% close the programm
m3d.release_desktop()

# Wait 3 seconds to allow AEDT to shut down before cleaning the temporary directory.
time.sleep(3)
temp_folder.cleanup()
ickness = 14.7, 10, 3.5

coil_thickness, coil_padding = 0.8 * yoke_z - yoke_thickness, 0.2
coil_thickness = 2.5
print("coil_thickness: ", coil_thickness)

rail_length = 245

rail_y, rail_z = yoke_thickness, yoke_z
rail_y = 10
rail_z = 1

# magnet_length = yoke_x + 2 * coil_thickness + 2 * coil_padding
magnet_length = yoke_x

region_pad = 10  # Padding around the model

band_length = 2 * rail_length - magnet_length
band_clearance, start_position, airgap = 0.1, 10, 1

velocity = 100e3
max_positive_limit = band_length - rail_length
print("Min Positive limit: ", start_position)
print("Max Positive limit: ", max_positive_limit)
print("velocity: ", velocity)
positive_limit = 100
travel_distance = positive_limit - start_position
print("Travel distance: ", travel_distance)

# %% create yoke
yoke = m3d.modeler.create_box(
    origin=[-yoke_x / 2, 0, 0],
    sizes=[
        yoke_x,
        rail_y + 2 * yoke_thickness,
        4 * yoke_thickness + rail_z + 2 * airgap,
    ],
    name="Yoke",
    material="iron",
)

yoke_cutout1 = m3d.modeler.create_box(
    origin=[-yoke_x / 2, 0, 2 * yoke_thickness],
    sizes=[yoke_x, rail_y, rail_z + 2 * airgap],
    name="Yoke_Cutout1",
)

yoke_cutout2 = m3d.modeler.create_box(
    origin=[-yoke_x / 2, rail_y, yoke_thickness],
    sizes=[yoke_x, yoke_thickness, rail_z + 2 * airgap + 2 * yoke_thickness],
    name="Yoke_Cutout2",
)

m3d.modeler.subtract(yoke, [yoke_cutout1, yoke_cutout2], keep_originals=False)

# %% create coil
coil = m3d.modeler.create_box(
    origin=[
        -yoke_x / 2 - coil_thickness - coil_padding,
        rail_y + yoke_thickness - coil_thickness - coil_padding,
        yoke_thickness + coil_padding,
    ],
    sizes=[
        2 * coil_thickness + 2 * coil_padding + yoke_x,
        2 * coil_thickness + 2 * coil_padding + yoke_thickness,
        rail_z + 2 * airgap + 2 * yoke_thickness - 2 * coil_padding,
    ],
    name="Coil",
    material="copper",
)

coil_cutout = m3d.modeler.create_box(
    origin=[
        -yoke_x / 2 - coil_padding,
        rail_y + yoke_thickness - coil_padding,
        yoke_thickness + coil_padding,
    ],
    sizes=[
        yoke_x + 2 * coil_padding,
        yoke_thickness + 2 * coil_padding,
        rail_z + 2 * airgap + 2 * yoke_thickness - 2 * coil_padding,
    ],
    name="Coil_Cutout",
)

m3d.modeler.subtract(coil, [coil_cutout], keep_originals=False)

section1 = m3d.modeler.section(assignment=coil, plane="YZ")
coil_termianl1 = coil.name + "_Section1"
m3d.modeler.separate_bodies(assignment=coil_termianl1)
m3d.modeler.delete(assignment=coil.name + "_Section1_Separate1")

# %% assign current
m3d.assign_winding(
    assignment=coil_termianl1,
    current=1e3,
    is_solid=False,
    name="Current_1",
)

# %% create rail
rail = m3d.modeler.create_box(
    origin=(yoke_x / 2 - rail_length, 0, 2 * yoke_thickness + airgap),
    sizes=(rail_length, rail_y, rail_z),
    name="Rail",
    material="iron",
)

# %% create region
region = m3d.modeler.create_box(
    origin=[yoke_x / 2 - rail_length - region_pad, -region_pad, -region_pad],
    sizes=[
        band_length + 2 * region_pad,
        rail_y + 2 * yoke_thickness + 2 * region_pad,
        4 * yoke_thickness + rail_z + 2 * airgap + 2 * region_pad,
    ],
    name="Region",
)

# %% create airgap
fine_airgap = m3d.modeler.create_box(
    origin=[-yoke_x / 2, 0, 2 * yoke_thickness],
    sizes=[yoke_x, rail_y, airgap - band_clearance],
    name="Fine_Airgap",
)

fine_airgap2 = m3d.modeler.create_box(
    origin=[-yoke_x / 2, 0, 2 * yoke_thickness + airgap + rail_z + band_clearance],
    sizes=[yoke_x, rail_y, airgap - band_clearance],
    name="Fine_Airgap2",
)

# %% create lines
line_count = 7

if line_count < 2:
    line_points = [
        [-yoke_x, rail_y / 2, 2 * yoke_thickness + airgap / 2],
        [yoke_x, rail_y / 2, 2 * yoke_thickness + airgap / 2],
    ]
    m3d.modeler.create_polyline(points=line_points, name="Line1")
else:
    delta_y = rail_y / (line_count - 1)
    for i in range(line_count):
        line_points = [
            [-yoke_x, i * delta_y, 2 * yoke_thickness + airgap / 2],
            [yoke_x, i * delta_y, 2 * yoke_thickness + airgap / 2],
        ]
        m3d.modeler.create_polyline(points=line_points, name=f"Line{i + 1}")

m3d.modeler.fit_all()

# %% assign motion
band_id = m3d.modeler.create_box(
    origin=[
        +yoke_x / 2 - rail_length - band_clearance,
        -band_clearance,
        2 * yoke_thickness + airgap - band_clearance,
    ],
    sizes=[
        band_length + 2 * band_clearance,
        rail_y + 2 * band_clearance,
        rail_z + 2 * band_clearance,
    ],
    name="Motion_Band",
)

m3d.assign_translate_motion(
    assignment=band_id,
    axis="X",
    start_position=start_position,
    periodic_translate=False,
    # negative_limit=-1,
    positive_limit=positive_limit,
    velocity=f"{velocity}{uom}_per_sec",
)

# %% apply mesh operations
m3d.mesh.assign_length_mesh(
    assignment=[fine_airgap, fine_airgap2],
    inside_selection=True,
    maximum_elements=None,
    maximum_length="0.5mm",
    name="Fine_Airgap_Mesh",
)

m3d.mesh.assign_skin_depth(
    assignment=[
        m3d.modeler.get_object_faces("Rail")[0],
        m3d.modeler.get_object_faces("Rail")[4],
    ],  # Use the bottom face of the rail
    # skin_depth="0.2mm",
    triangulation_max_length="0.4mm",
    layers_number=4,
    name="Rail_Surface_Mesh",
)

# %% turn on eddy effects
m3d.eddy_effects_on(assignment=["Rail"])

# %% set up simulation
stop_time = (
    travel_distance
) / velocity  # Time to cover the band length at the given velocity
time_accuracy = 1e-5

if time_accuracy > stop_time:  # to avoid having time step larger than stop time
    time_accuracy = stop_time

setup = m3d.create_setup("Setup1")
setup.props["StopTime"] = f"{stop_time}s"
setup.props["TimeStep"] = f"{time_accuracy}s"

setup.props["SaveFieldsType"] = "Every N Steps"
setup.props["N Steps"] = 2
setup.props["Steps To"] = f"{stop_time}s"

setup.props["NonlinearSolverResidual"] = 1e-5

setup.update()

print(
    f"Stop time: {stop_time}s, Time step: {time_accuracy}, steps={int(stop_time / (time_accuracy))}"
)

# %% analyze
m3d.analyze_setup("Setup1")

# %% save project
m3d.save_project(
    file_name=r"C:\Users\Aerodynamics\Julian_Schueler_Ansys\yamamura_y10_long.aedt",
    overwrite=True,
)

# %% close the programm
m3d.release_desktop()

# Wait 3 seconds to allow AEDT to shut down before cleaning the temporary directory.
time.sleep(3)
temp_folder.cleanup()
