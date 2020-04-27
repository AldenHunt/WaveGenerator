
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name Thesis -dir "/home/ise/ise_projects/Thesis/planAhead_run_3" -part xc6slx150fgg484-2
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "/home/ise/ise_projects/Thesis/top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/ise/ise_projects/Thesis} {ipcore_dir} }
add_files [list {ipcore_dir/two_clk_fifo.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "top.ucf" [current_fileset -constrset]
add_files [list {top.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "/home/ise/ise_projects/Thesis/top.ncd"
if {[catch {read_twx -name results_1 -file "/home/ise/ise_projects/Thesis/top.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"/home/ise/ise_projects/Thesis/top.twx\": $eInfo"
}
