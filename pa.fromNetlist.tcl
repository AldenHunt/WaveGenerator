
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name Thesis -dir "/home/ise/ise_projects/Thesis/planAhead_run_3" -part xc6slx150fgg484-2
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/home/ise/ise_projects/Thesis/top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/ise/ise_projects/Thesis} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "top.ucf" [current_fileset -constrset]
add_files [list {top.ucf}] -fileset [get_property constrset [current_run]]
link_design
