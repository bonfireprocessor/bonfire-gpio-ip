package require xilinx::board 1.0
namespace import ::xilinx::board::*

proc get_gpio_board_interface_vlnv {} {
	return "xilinx.com:interface:gpio_rtl:1.0"
}

#proc init_params {IPINST PARAM_VALUE.GPIO_BOARD_INTERFACE } {
#  set_property preset_proc "GPIO_BOARD_INTERFACE_PRESET" ${PARAM_VALUE.GPIO_BOARD_INTERFACE}
#}

#proc GPIO_BOARD_INTERFACE_PRESET {IPINST PRESET_VALUE} {
#  if { $PRESET_VALUE == "Custom" } {
#    return ""
#  }
#  set board [::ipxit::get_project_property BOARD]
#  set vlnv [get_property ipdef $IPINST] 
#  set preset_params [board_ip_presets $vlnv $PRESET_VALUE $board "GPIO"]
#  if { $preset_params != "" } {
#    return $preset_params
#  } else {
#    return ""
#  }
#}

# Definitional proc to organize widgets for parameters.
proc init_gui {IPINST PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.BOARD} {
  set c_family ${PROJECT_PARAM.ARCHITECTURE}
  set board ${PROJECT_PARAM.BOARD}
  set Component_Name [ ipgui::add_param  $IPINST  -parent  $IPINST  -name Component_Name ]
	
  ipgui::add_param $IPINST -name "Component_Name"
 
  #i::add_param $IPINST -name "GPIO_BOARD_INTERFACE" -widget comboBox
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "IP Configuration"]
  ipgui::add_param $IPINST -name "ADRWIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FAST_READ_TERM" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NUM_GPIO" -parent ${Page_0}

   add_board_tab $IPINST
 

}

proc update_PARAM_VALUE.ADRWIDTH { PARAM_VALUE.ADRWIDTH } {
	# Procedure called to update ADRWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADRWIDTH { PARAM_VALUE.ADRWIDTH } {
	# Procedure called to validate ADRWIDTH
	return true
}

proc update_PARAM_VALUE.GPIO_BOARD_INTERFACE {IPINST PARAM_VALUE.GPIO_BOARD_INTERFACE PROJECT_PARAM.BOARD} {
    puts "##Update"
	set param_range [get_board_interface_param_range $IPINST -name "GPIO_BOARD_INTERFACE"]
	puts $param_range
	set_property range $param_range ${PARAM_VALUE.GPIO_BOARD_INTERFACE}
}


proc validate_PARAM_VALUE.GPIO_BOARD_INTERFACE { PARAM_VALUE.GPIO_BOARD_INTERFACE PARAM_VALUE.USE_BOARD_FLOW IPINST PROJECT_PARAM.BOARD} {
    puts "##Validate"
	set gpio_board_interface [get_gpio_board_interface_vlnv]
	set intf [ get_property value ${PARAM_VALUE.GPIO_BOARD_INTERFACE} ]
	set board ${PROJECT_PARAM.BOARD}
	return true
}

proc update_PARAM_VALUE.FAST_READ_TERM { PARAM_VALUE.FAST_READ_TERM } {
	# Procedure called to update FAST_READ_TERM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FAST_READ_TERM { PARAM_VALUE.FAST_READ_TERM } {
	# Procedure called to validate FAST_READ_TERM
	return true
}

proc update_PARAM_VALUE.NUM_GPIO { PARAM_VALUE.NUM_GPIO PARAM_VALUE.GPIO_BOARD_INTERFACE  PROJECT_PARAM.BOARD} {
	set boardIfName [get_property value ${PARAM_VALUE.GPIO_BOARD_INTERFACE}]
	puts $boardIfName
	if { $boardIfName ne "Custom"} {
	   	set tri_o [get_board_part_pins_of_intf_port $boardIfName TRI_O] 
		set tri_i [get_board_part_pins_of_intf_port $boardIfNam TRI_I] 
		if { $tri_o eq "" && $tri_i ne "" } {
			set port_width [get_width_of_intf_port $boardIfName TRI_I]
			set_property value $port_width ${PARAM_VALUE.NUM_GPIO}
		} elseif { $tri_o ne "" && $tri_i eq "" } {
			set port_width [get_width_of_intf_port $boardIfName TRI_O]
			set_property value $port_width ${PARAM_VALUE.NUM_GPIO}
		} else {
			set port_width [get_width_of_intf_port $boardIfName TRI_O]
			set_property value $port_width ${PARAM_VALUE.NUM_GPIO}
		}	
	   set_property enabled false ${PARAM_VALUE.NUM_GPIO}
	} else {
	   set_property enabled true ${PARAM_VALUE.NUM_GPIO}
	}
}

proc validate_PARAM_VALUE.NUM_GPIO { PARAM_VALUE.NUM_GPIO } {
	# Procedure called to validate NUM_GPIO
	return true
}


proc update_MODELPARAM_VALUE.ADRWIDTH { MODELPARAM_VALUE.ADRWIDTH PARAM_VALUE.ADRWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADRWIDTH}] ${MODELPARAM_VALUE.ADRWIDTH}
}

proc update_MODELPARAM_VALUE.FAST_READ_TERM { MODELPARAM_VALUE.FAST_READ_TERM PARAM_VALUE.FAST_READ_TERM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FAST_READ_TERM}] ${MODELPARAM_VALUE.FAST_READ_TERM}
}

proc update_MODELPARAM_VALUE.NUM_GPIO { MODELPARAM_VALUE.NUM_GPIO PARAM_VALUE.NUM_GPIO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_GPIO}] ${MODELPARAM_VALUE.NUM_GPIO}
}







## Definitional proc to organize widgets for parameters.
#proc init_gui { IPINST } {
#  ipgui::add_param $IPINST -name "Component_Name"
#  ipgui::add_param $IPINST -name "GPIO_BOARD_INTERFACE" -widget comboBox
#  #Adding Page
#  set IP_Configuration [ipgui::add_page $IPINST -name "IP Configuration"]
#  ipgui::add_param $IPINST -name "ADRWIDTH" -parent ${IP_Configuration}
#  ipgui::add_param $IPINST -name "FAST_READ_TERM" -parent ${IP_Configuration}
#  ipgui::add_param $IPINST -name "NUM_GPIO" -parent ${IP_Configuration}


#}

#proc update_PARAM_VALUE.ADRWIDTH { PARAM_VALUE.ADRWIDTH } {
#	# Procedure called to update ADRWIDTH when any of the dependent parameters in the arguments change
#}

#proc validate_PARAM_VALUE.ADRWIDTH { PARAM_VALUE.ADRWIDTH } {
#	# Procedure called to validate ADRWIDTH
#	return true
#}

#proc update_PARAM_VALUE.FAST_READ_TERM { PARAM_VALUE.FAST_READ_TERM } {
#	# Procedure called to update FAST_READ_TERM when any of the dependent parameters in the arguments change
#}

#proc validate_PARAM_VALUE.FAST_READ_TERM { PARAM_VALUE.FAST_READ_TERM } {
#	# Procedure called to validate FAST_READ_TERM
#	return true
#}

#proc update_PARAM_VALUE.GPIO_BOARD_INTERFACE { PARAM_VALUE.GPIO_BOARD_INTERFACE } {
#	# Procedure called to update GPIO_BOARD_INTERFACE when any of the dependent parameters in the arguments change
#}

#proc validate_PARAM_VALUE.GPIO_BOARD_INTERFACE { PARAM_VALUE.GPIO_BOARD_INTERFACE } {
#	# Procedure called to validate GPIO_BOARD_INTERFACE
#	return true
#}

#proc update_PARAM_VALUE.NUM_GPIO { PARAM_VALUE.NUM_GPIO } {
#	# Procedure called to update NUM_GPIO when any of the dependent parameters in the arguments change
#}

#proc validate_PARAM_VALUE.NUM_GPIO { PARAM_VALUE.NUM_GPIO } {
#	# Procedure called to validate NUM_GPIO
#	return true
#}

#proc update_PARAM_VALUE.USE_BOARD_FLOW { PARAM_VALUE.USE_BOARD_FLOW } {
#	# Procedure called to update USE_BOARD_FLOW when any of the dependent parameters in the arguments change
#}

#proc validate_PARAM_VALUE.USE_BOARD_FLOW { PARAM_VALUE.USE_BOARD_FLOW } {
#	# Procedure called to validate USE_BOARD_FLOW
#	return true
#}


#proc update_MODELPARAM_VALUE.ADRWIDTH { MODELPARAM_VALUE.ADRWIDTH PARAM_VALUE.ADRWIDTH } {
#	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
#	set_property value [get_property value ${PARAM_VALUE.ADRWIDTH}] ${MODELPARAM_VALUE.ADRWIDTH}
#}

#proc update_MODELPARAM_VALUE.FAST_READ_TERM { MODELPARAM_VALUE.FAST_READ_TERM PARAM_VALUE.FAST_READ_TERM } {
#	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
#	set_property value [get_property value ${PARAM_VALUE.FAST_READ_TERM}] ${MODELPARAM_VALUE.FAST_READ_TERM}
#}

#proc update_MODELPARAM_VALUE.NUM_GPIO { MODELPARAM_VALUE.NUM_GPIO PARAM_VALUE.NUM_GPIO } {
#	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
#	set_property value [get_property value ${PARAM_VALUE.NUM_GPIO}] ${MODELPARAM_VALUE.NUM_GPIO}
#}

