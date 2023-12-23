##Switches
set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { sws_4bits_tri_i[0] }]; #IO_L19N_T3_VREF_35 Sch=SW0
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { sws_4bits_tri_i[1] }]; #IO_L24P_T3_34      Sch=SW1
set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports { sws_4bits_tri_i[2] }]; #IO_L4N_T0_34       Sch=SW2
set_property -dict { PACKAGE_PIN T16   IOSTANDARD LVCMOS33 } [get_ports { sws_4bits_tri_i[3] }]; #IO_L9P_T1_DQS_34   Sch=SW3

##Buttons
set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { btns_4bits_tri_i[0] }]; #IO_L20N_T3_34 Sch=BTN0
set_property -dict { PACKAGE_PIN P16   IOSTANDARD LVCMOS33 } [get_ports { btns_4bits_tri_i[1] }]; #IO_L24N_T3_34 Sch=BTN1
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { btns_4bits_tri_i[2] }]; #IO_L18P_T2_34 Sch=BTN2
set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS33 } [get_ports { btns_4bits_tri_i[3] }]; #IO_L7P_T1_34  Sch=BTN3

##LEDs
set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { leds_4bits_tri_o[0] }]; #IO_L23P_T3_35         Sch=LED0
set_property -dict { PACKAGE_PIN M15   IOSTANDARD LVCMOS33 } [get_ports { leds_4bits_tri_o[1] }]; #IO_L23N_T3_35         Sch=LED1
set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { leds_4bits_tri_o[2] }]; #IO_0_35               Sch=LED2
set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVCMOS33 } [get_ports { leds_4bits_tri_o[3] }]; #IO_L3N_T0_DQS_AD1N_35 Sch=LED3

##I2C for EPPROM with ethernet MAC and audio codec (SSM2603) configuration
set_property -dict { PACKAGE_PIN N18   IOSTANDARD LVCMOS33 } [get_ports { IIC_0_scl_io }];
set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { IIC_0_sda_io }];
