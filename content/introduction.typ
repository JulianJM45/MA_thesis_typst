#import "/utils/todo.typ": TODO


= Introduction

Transportation is one of the big challenges of our society. Since conventual transportation systems lack on efficiency, new solutions for transportation are being searched.

 One way to achieve more efficiency is to get rid of the friction of wheels by enabling magnetic levitation. This method is for example applied in the MagLev trains like Transrapid or in the emerging Hyperloop project.
There are three main principles for magnetic levitation to differentiate: electromangetic suspension (EMS), electrodynamic suspension (EDS) and superconducting suspension @radeck2020. While EDS and superconducting suspension are passive systems which have repelling forces, EMS is an actively controlled system that uses electromanets to generate attracting forces on a rail.

At EMS, the rail has to be a magnetic material like iron or steel. The electromanet generates a magnetic field which forms a magnetic circuit through the electromagnets core, its limbs and the rail. Since flux lines try to shorten their path, they generate a force which attracts coil and rail to each other. This is the attractive force that is used to levitate the vehicle @mag_circuit.
In general there are two types of the arrangement of the magnets, homogen and heterogen arrangement. In the heterogen arrangement the orientation of the magnetic field is alternating in the direction of the motion. This is used by the Transrapid and enableds the simultaneous use of leviation and propulsion of the rail.\
In the homogen arrangement the orientation of the magnetic field is the same in the direction of motion. This concept is used by the TUM Hyperloop and requires a separate propulsion system to move the vehicle but allows a far more simple design of the levitation system.

When the vehicle is moving over the rail, eddy currents are induced in the rail due to the changing magnetic field. These eddy currents are disadvantageous for two reasons: they produce a drag force which brakes the vehicle and they also induce a counteracting magnetic field which imbalances and reduces the leviation force in direction of motion and could tilt the vehicle.

Since in the homogen arrangement the magnetic field is the same in the direction of motion and does only change at the beginning and end of the magnets, this design is promising for reducing eddy currents and thus increasing the efficiency of the system. The eddy currents increase with the velocity of the vehicle and therefore of high interest at high velocities like in the Hyperloop.


In this thesis we will investigate the induced eddy currents in the rail of a homogen EMS system. We will start with the theoretical basics of electromagnetism in @chapter:theory, namely Maxwell's equations, the Lorentz force and the generation of magnetic fields by electric currents. We will then discuss the concept of induced eddy currents in a simplified EMS system in @chapter:eddy_currents_models and derive various models to describe the eddy currents and their effects on the magnetic field. We will then simualte the eddy currents with the finite element method with Ansys software in @chapter:simulation and compare the results with the theoretical model.
Finally, we will summarize the results and discuss further research directions in @chapter:summary.
