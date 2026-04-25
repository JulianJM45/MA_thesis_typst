#import "/utils/todo.typ": TODO


= Introduction

Transportation is one of the major challenges of our society. Since conventional transportation systems lack efficiency, new solutions for transportation are being sought.

One way to achieve higher efficiency is to eliminate the friction of wheels by enabling magnetic levitation. This method is applied, for example, in the MagLev trains like Transrapid or in the emerging Hyperloop project.
There are three main principles for magnetic levitation to differentiate: electromagnetic suspension (EMS), electrodynamic suspension (EDS), and superconducting suspension @radeck2020. While EDS and superconducting suspension are passive systems that have repelling forces, EMS is an actively controlled system that uses electromagnets to generate attracting forces on a rail.

In EMS, the rail has to be a magnetic material like iron or steel. The electromagnet generates a magnetic field that forms a magnetic circuit through the electromagnet's core, its limbs, and the rail. Since flux lines try to shorten their path, they generate a force that attracts the coil and rail to each other. This is the attractive force that is used to levitate the vehicle @mag_circuit.
In general, there are two types of magnet arrangement: homogeneous and heterogeneous arrangement. In the heterogeneous arrangement, the orientation of the magnetic field alternates in the direction of motion. This is used by the Transrapid @schmid2021 and enables the simultaneous use of levitation and propulsion of the rail @transrapid_dot_report.\
In the homogeneous arrangement, the orientation of the magnetic field is the same in the direction of motion. This concept is used by TUM Hyperloop and requires a separate propulsion system to move the vehicle but allows a far simpler design of the levitation system @kleikemper2025.

When the vehicle is moving over the rail, eddy currents are induced in the rail due to the magnetic field. These eddy currents are disadvantageous for two reasons: they produce a drag force that brakes the vehicle, and they also induce a counteracting magnetic field that imbalances and reduces the levitation force in the direction of motion and could tilt the vehicle.

Since in the homogeneous arrangement the magnetic field is the same in the direction of motion and changes only at the beginning and end of the magnets, this design is promising for reducing eddy currents and thus increasing the efficiency of the system. The eddy currents increase with the velocity of the vehicle and are therefore of high interest at high velocities like in the Hyperloop.


In this thesis, we will investigate the induced eddy currents in the rail of a homogeneous EMS system. We will start with the theoretical basics of electromagnetism in @chapter:theory, namely Maxwell's equations, the Lorentz force, and the generation of magnetic fields by electric currents. We will then discuss the concept of induced eddy currents in a simplified EMS system in @chapter:eddy_currents_models and derive various models to describe the eddy currents and their effects on the magnetic field. We will then simulate the eddy currents with the finite element method using Ansys software in @chapter:simulation and compare the results with the theoretical models.
Finally, we will summarize the results and discuss further research directions in @chapter:summary.
