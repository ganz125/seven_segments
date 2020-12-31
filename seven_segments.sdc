create_clock -name "clock_50M" -period 20.00ns [get_ports {clock_50M}]
derive_clock_uncertainty
