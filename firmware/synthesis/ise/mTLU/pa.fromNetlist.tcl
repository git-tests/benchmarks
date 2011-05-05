
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name mTLU -dir "/afs/phy.bris.ac.uk/cad/designs/fmc-mtlu/trunk/firmware/synthesis/ise/mTLU/planAhead_run_1" -part xc6slx16csg324-2
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/afs/phy.bris.ac.uk/cad/designs/fmc-mtlu/trunk/firmware/synthesis/ise/mTLU/fmc_tlu_sp601.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/afs/phy.bris.ac.uk/cad/designs/fmc-mtlu/trunk/firmware/synthesis/ise/mTLU} }
set_param project.paUcfFile  "/afs/phy.bris.ac.uk/cad/designs/fmc-mtlu/trunk/firmware/src/sp601.ucf"
add_files "/afs/phy.bris.ac.uk/cad/designs/fmc-mtlu/trunk/firmware/src/sp601.ucf" -fileset [get_property constrset [current_run]]
open_netlist_design
