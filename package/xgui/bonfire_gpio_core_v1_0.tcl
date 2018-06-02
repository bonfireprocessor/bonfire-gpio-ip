# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADRWIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FAST_READ_TERM" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NUM_GPIO" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADRWIDTH { PARAM_VALUE.ADRWIDTH } {
	# Procedure called to update ADRWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADRWIDTH { PARAM_VALUE.ADRWIDTH } {
	# Procedure called to validate ADRWIDTH
	return true
}

proc update_PARAM_VALUE.FAST_READ_TERM { PARAM_VALUE.FAST_READ_TERM } {
	# Procedure called to update FAST_READ_TERM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FAST_READ_TERM { PARAM_VALUE.FAST_READ_TERM } {
	# Procedure called to validate FAST_READ_TERM
	return true
}

proc update_PARAM_VALUE.NUM_GPIO { PARAM_VALUE.NUM_GPIO } {
	# Procedure called to update NUM_GPIO when any of the dependent parameters in the arguments change
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

