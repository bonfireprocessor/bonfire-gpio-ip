----------------------------------------------------------------------------------
 
-- Module Name: bonfire_gpio_core - Behavioral
-- The Bonfire Processor Project, (c) 2016,2017,2018 Thomas Hornschuh

-- Description: 
-- Toplevel for IP Packager. Was originally created with a block design 
-- License: See LICENSE or LICENSE.txt File in git project root. 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bonfire_gpio_core is
generic(
   ADRWIDTH  : integer := 15; -- Width of the AXI Address Bus, the Wishbone Adr- Bus coresponds with it, but without the lowest adress bits
   FAST_READ_TERM : boolean := TRUE; -- TRUE: Allows AXI read termination in same cycle as 
   NUM_GPIO : natural :=32
);
 port (
   ---------------------------------------------------------------------------
   -- AXI Interface
   ---------------------------------------------------------------------------
   -- Clock and Reset
   S_AXI_ACLK    : in  std_logic;
   S_AXI_ARESETN : in  std_logic;
   -- Write Address Channel
   S_AXI_AWADDR  : in  std_logic_vector(ADRWIDTH-1 downto 0);
   S_AXI_AWVALID : in  std_logic;
   S_AXI_AWREADY : out std_logic;
   -- Write Data Channel
   S_AXI_WDATA   : in  std_logic_vector(31 downto 0);
   S_AXI_WSTRB   : in  std_logic_vector(3 downto 0);
   S_AXI_WVALID  : in  std_logic;
   S_AXI_WREADY  : out std_logic;
   -- Read Address Channel
   S_AXI_ARADDR  : in  std_logic_vector(ADRWIDTH-1 downto 0);
   S_AXI_ARVALID : in  std_logic;
   S_AXI_ARREADY : out std_logic;
   -- Read Data Channel
   S_AXI_RDATA   : out std_logic_vector(31 downto 0);
   S_AXI_RRESP   : out std_logic_vector(1 downto 0);
   S_AXI_RVALID  : out std_logic;
   S_AXI_RREADY  : in  std_logic;
   -- Write Response Channel
   S_AXI_BRESP   : out std_logic_vector(1 downto 0);
   S_AXI_BVALID  : out std_logic;
   S_AXI_BREADY  : in  std_logic;
   
    GPIO_tri_i : in STD_LOGIC_VECTOR ( NUM_GPIO-1 downto 0 );
    GPIO_tri_o : out STD_LOGIC_VECTOR (NUM_GPIO-1 downto 0 );
    GPIO_tri_t : out STD_LOGIC_VECTOR (NUM_GPIO-1 downto 0 );
    
       -- irq outs
     rise_irq_o : out std_logic;
     fall_irq_o : out std_logic;
     high_irq_o : out std_logic;
     low_irq_o : out std_logic

);   
end bonfire_gpio_core;
architecture Behavioral of bonfire_gpio_core is

component bonfire_gpio is
  generic (
     maxIObit : natural := 7;  -- Adr bus  high
     minIObit : natural := 2;   -- Adr bus  low
     NUM_GPIO_BITS : natural := 32
  );
  port (
    wb_clk_i : in STD_LOGIC;
    wb_rst_i : in STD_LOGIC;
    wb_dat_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    wb_dat_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    wb_adr_i : in STD_LOGIC_VECTOR ( 7 downto 2 );
    wb_we_i : in STD_LOGIC;
    wb_cyc_i : in STD_LOGIC;
    wb_stb_i : in STD_LOGIC;
    wb_ack_o : out STD_LOGIC;
    rise_irq_o : out STD_LOGIC;
    fall_irq_o : out STD_LOGIC;
    high_irq_o : out STD_LOGIC;
    low_irq_o : out STD_LOGIC;
    gpio_o : out STD_LOGIC_VECTOR ( NUM_GPIO-1 downto 0 );
    gpio_i : in STD_LOGIC_VECTOR ( NUM_GPIO-1 downto 0 );
    gpio_t : out STD_LOGIC_VECTOR ( NUM_GPIO-1 downto 0 )
  );
end component;

component bonfire_axi4l2wb is
generic (
    ADRWIDTH  : integer := 15; -- Width of the AXI Address Bus, the Wishbone Adr- Bus coresponds with it, but without the lowest adress bits
    FAST_READ_TERM : boolean := TRUE -- TRUE: Allows AXI read termination in same cycle as 
    );
  port (
    S_AXI_ACLK : in STD_LOGIC;
    S_AXI_ARESETN : in STD_LOGIC;
    S_AXI_AWADDR : in STD_LOGIC_VECTOR ( 14 downto 0 );
    S_AXI_AWVALID : in STD_LOGIC;
    S_AXI_AWREADY : out STD_LOGIC;
    S_AXI_WDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_WSTRB : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_WVALID : in STD_LOGIC;
    S_AXI_WREADY : out STD_LOGIC;
    S_AXI_ARADDR : in STD_LOGIC_VECTOR ( 14 downto 0 );
    S_AXI_ARVALID : in STD_LOGIC;
    S_AXI_ARREADY : out STD_LOGIC;
    S_AXI_RDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_RRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_RVALID : out STD_LOGIC;
    S_AXI_RREADY : in STD_LOGIC;
    S_AXI_BRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_BVALID : out STD_LOGIC;
    S_AXI_BREADY : in STD_LOGIC;
    wb_clk_o : out STD_LOGIC;
    wb_rst_o : out STD_LOGIC;
    wb_addr_o : out STD_LOGIC_VECTOR ( 14 downto 2 );
    wb_dat_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    wb_we_o : out STD_LOGIC;
    wb_sel_o : out STD_LOGIC_VECTOR ( 3 downto 0 );
    wb_stb_o : out STD_LOGIC;
    wb_cyc_o : out STD_LOGIC;
    wb_dat_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    wb_ack_i : in STD_LOGIC
  );
  end component;
  
    signal S_AXI_1_ARADDR : STD_LOGIC_VECTOR ( 14 downto 0 );
    signal S_AXI_1_ARREADY : STD_LOGIC;
    signal S_AXI_1_ARVALID : STD_LOGIC;
    signal S_AXI_1_AWADDR : STD_LOGIC_VECTOR ( 14 downto 0 );
    signal S_AXI_1_AWREADY : STD_LOGIC;
    signal S_AXI_1_AWVALID : STD_LOGIC;
    signal S_AXI_1_BREADY : STD_LOGIC;
    signal S_AXI_1_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
    signal S_AXI_1_BVALID : STD_LOGIC;
    signal S_AXI_1_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
    signal S_AXI_1_RREADY : STD_LOGIC;
    signal S_AXI_1_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
    signal S_AXI_1_RVALID : STD_LOGIC;
    signal S_AXI_1_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
    signal S_AXI_1_WREADY : STD_LOGIC;
    signal S_AXI_1_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
    signal S_AXI_1_WVALID : STD_LOGIC;
    signal S_AXI_ACLK_1 : STD_LOGIC;
    signal S_AXI_ARESETN_1 : STD_LOGIC;
    signal bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_ack_i : STD_LOGIC;
    signal bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_adr_o : STD_LOGIC_VECTOR ( 14 downto 2 );
    signal bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_cyc_o : STD_LOGIC;
    signal bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_dat_i : STD_LOGIC_VECTOR ( 31 downto 0 );
    signal bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_dat_o : STD_LOGIC_VECTOR ( 31 downto 0 );
    signal bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_stb_o : STD_LOGIC;
    signal bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_we_o : STD_LOGIC;
    signal bonfire_axi4l2wb_0_wb_clk_o : STD_LOGIC;
    signal bonfire_axi4l2wb_0_wb_rst_o : STD_LOGIC;
    signal bonfire_gpio_0_GPIO_TRI_I : STD_LOGIC_VECTOR ( NUM_GPIO-1 downto 0 );
    signal bonfire_gpio_0_GPIO_TRI_O : STD_LOGIC_VECTOR ( NUM_GPIO-1 downto 0 );
    signal bonfire_gpio_0_GPIO_TRI_T : STD_LOGIC_VECTOR ( NUM_GPIO-1 downto 0 );
    signal bonfire_gpio_0_fall_irq_o : STD_LOGIC;
    signal bonfire_gpio_0_high_irq_o : STD_LOGIC;
    signal bonfire_gpio_0_low_irq_o : STD_LOGIC;
    signal bonfire_gpio_0_rise_irq_o : STD_LOGIC;
    signal NLW_bonfire_axi4l2wb_0_wb_sel_o_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
    
    
    attribute X_INTERFACE_INFO : string;
    attribute X_INTERFACE_INFO of S_AXI_ACLK : signal is "xilinx.com:signal:clock:1.0 S_AXI_ACLK CLK";
    attribute X_INTERFACE_PARAMETER : string;
    attribute X_INTERFACE_PARAMETER of S_AXI_ACLK : signal is "XIL_INTERFACENAME S_AXI_ACLK, ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET S_AXI_ARESETN"; -- CLK_DOMAIN design_1_S_AXI_ACLK, FREQ_HZ 100000000, PHASE 0.000";
    attribute X_INTERFACE_INFO of S_AXI_ARESETN : signal is "xilinx.com:signal:reset:1.0 S_AXI_ARESETN RST";
    attribute X_INTERFACE_PARAMETER of S_AXI_ARESETN : signal is "XIL_INTERFACENAME S_AXI_ARESETN, POLARITY ACTIVE_LOW";
    
    
    attribute X_INTERFACE_INFO of S_AXI_arready : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARREADY";
    attribute X_INTERFACE_INFO of S_AXI_arvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARVALID";
    attribute X_INTERFACE_INFO of S_AXI_awready : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWREADY";
    attribute X_INTERFACE_INFO of S_AXI_awvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWVALID";
    attribute X_INTERFACE_INFO of S_AXI_bready : signal is "xilinx.com:interface:aximm:1.0 S_AXI BREADY";
    attribute X_INTERFACE_INFO of S_AXI_bvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI BVALID";
    attribute X_INTERFACE_INFO of S_AXI_rready : signal is "xilinx.com:interface:aximm:1.0 S_AXI RREADY";
    attribute X_INTERFACE_INFO of S_AXI_rvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI RVALID";
    attribute X_INTERFACE_INFO of S_AXI_wready : signal is "xilinx.com:interface:aximm:1.0 S_AXI WREADY";
    attribute X_INTERFACE_INFO of S_AXI_wvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI WVALID";
    attribute X_INTERFACE_INFO of S_AXI_araddr : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARADDR";
    --attribute X_INTERFACE_PARAMETER of S_AXI_araddr : signal is "XIL_INTERFACENAME S_AXI, ADDR_WIDTH 16, ARUSER_WIDTH 0, AWUSER_WIDTH 0, BUSER_WIDTH 0, CLK_DOMAIN design_1_S_AXI_ACLK, DATA_WIDTH 32, FREQ_HZ 100000000, HAS_BRESP 1, HAS_BURST 1, HAS_CACHE 1, HAS_LOCK 1, HAS_PROT 1, HAS_QOS 1, HAS_REGION 1, HAS_RRESP 1, HAS_WSTRB 1, ID_WIDTH 0, MAX_BURST_LENGTH 1, NUM_READ_OUTSTANDING 1, NUM_READ_THREADS 1, NUM_WRITE_OUTSTANDING 1, NUM_WRITE_THREADS 1, PHASE 0.000, PROTOCOL AXI4LITE, READ_WRITE_MODE READ_WRITE, RUSER_BITS_PER_BYTE 0, RUSER_WIDTH 0, SUPPORTS_NARROW_BURST 0, WUSER_BITS_PER_BYTE 0, WUSER_WIDTH 0";
    attribute X_INTERFACE_INFO of S_AXI_awaddr : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWADDR";
    attribute X_INTERFACE_INFO of S_AXI_bresp : signal is "xilinx.com:interface:aximm:1.0 S_AXI BRESP";
    attribute X_INTERFACE_INFO of S_AXI_rdata : signal is "xilinx.com:interface:aximm:1.0 S_AXI RDATA";
    attribute X_INTERFACE_INFO of S_AXI_rresp : signal is "xilinx.com:interface:aximm:1.0 S_AXI RRESP";
    attribute X_INTERFACE_INFO of S_AXI_wdata : signal is "xilinx.com:interface:aximm:1.0 S_AXI WDATA";
    attribute X_INTERFACE_INFO of S_AXI_wstrb : signal is "xilinx.com:interface:aximm:1.0 S_AXI WSTRB";    
    
    
    attribute X_INTERFACE_INFO of fall_irq_o : signal is "xilinx.com:signal:interrupt:1.0 INTR.FALL_IRQ_O INTERRUPT";
    attribute X_INTERFACE_PARAMETER of fall_irq_o : signal is "XIL_INTERFACENAME INTR.FALL_IRQ_O, PortWidth 1, SENSITIVITY LEVEL_HIGH";
    attribute X_INTERFACE_INFO of high_irq_o : signal is "xilinx.com:signal:interrupt:1.0 INTR.HIGH_IRQ_O INTERRUPT";
    attribute X_INTERFACE_PARAMETER of high_irq_o : signal is "XIL_INTERFACENAME INTR.HIGH_IRQ_O, PortWidth 1, SENSITIVITY LEVEL_HIGH";
    attribute X_INTERFACE_INFO of low_irq_o : signal is "xilinx.com:signal:interrupt:1.0 INTR.LOW_IRQ_O INTERRUPT";
    attribute X_INTERFACE_PARAMETER of low_irq_o : signal is "XIL_INTERFACENAME INTR.LOW_IRQ_O, PortWidth 1, SENSITIVITY LEVEL_HIGH";
    attribute X_INTERFACE_INFO of rise_irq_o : signal is "xilinx.com:signal:interrupt:1.0 INTR.RISE_IRQ_O INTERRUPT";
    attribute X_INTERFACE_PARAMETER of rise_irq_o : signal is "XIL_INTERFACENAME INTR.RISE_IRQ_O, PortWidth 1, SENSITIVITY LEVEL_HIGH";
    attribute X_INTERFACE_INFO of GPIO_tri_i : signal is "xilinx.com:interface:gpio:1.0 GPIO TRI_I";
    attribute X_INTERFACE_INFO of GPIO_tri_o : signal is "xilinx.com:interface:gpio:1.0 GPIO TRI_O";
    attribute X_INTERFACE_INFO of GPIO_tri_t : signal is "xilinx.com:interface:gpio:1.0 GPIO TRI_T";
    
begin


  GPIO_tri_o(NUM_GPIO-1 downto 0) <= bonfire_gpio_0_GPIO_TRI_O(NUM_GPIO-1 downto 0);
  GPIO_tri_t(NUM_GPIO-1 downto 0) <= bonfire_gpio_0_GPIO_TRI_T(NUM_GPIO-1 downto 0);
  bonfire_gpio_0_GPIO_TRI_I(NUM_GPIO-1 downto 0) <= GPIO_tri_i(NUM_GPIO-1 downto 0);
   
  S_AXI_1_ARADDR(14 downto 0) <= S_AXI_araddr(14 downto 0);
  S_AXI_1_ARVALID <= S_AXI_arvalid;
  S_AXI_1_AWADDR(14 downto 0) <= S_AXI_awaddr(14 downto 0);
  S_AXI_1_AWVALID <= S_AXI_awvalid;
  S_AXI_1_BREADY <= S_AXI_bready;
  S_AXI_1_RREADY <= S_AXI_rready;
  S_AXI_1_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  S_AXI_1_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  S_AXI_1_WVALID <= S_AXI_wvalid;
  S_AXI_ACLK_1 <= S_AXI_ACLK;
  S_AXI_ARESETN_1 <= S_AXI_ARESETN;
  S_AXI_arready <= S_AXI_1_ARREADY;
  S_AXI_awready <= S_AXI_1_AWREADY;
  S_AXI_bresp(1 downto 0) <= S_AXI_1_BRESP(1 downto 0);
  S_AXI_bvalid <= S_AXI_1_BVALID;
  S_AXI_rdata(31 downto 0) <= S_AXI_1_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= S_AXI_1_RRESP(1 downto 0);
  S_AXI_rvalid <= S_AXI_1_RVALID;
  S_AXI_wready <= S_AXI_1_WREADY;
 
  fall_irq_o <= bonfire_gpio_0_fall_irq_o;
  high_irq_o <= bonfire_gpio_0_high_irq_o;
  low_irq_o <= bonfire_gpio_0_low_irq_o;
  rise_irq_o <= bonfire_gpio_0_rise_irq_o;
  
  bonfire_axi4l2wb_0: component bonfire_axi4l2wb
       generic map (
         ADRWIDTH=>ADRWIDTH,
         FAST_READ_TERM=>FAST_READ_TERM
       )
       port map (
        S_AXI_ACLK => S_AXI_ACLK_1,
        S_AXI_ARADDR(14 downto 0) => S_AXI_1_ARADDR(14 downto 0),
        S_AXI_ARESETN => S_AXI_ARESETN_1,
        S_AXI_ARREADY => S_AXI_1_ARREADY,
        S_AXI_ARVALID => S_AXI_1_ARVALID,
        S_AXI_AWADDR(14 downto 0) => S_AXI_1_AWADDR(14 downto 0),
        S_AXI_AWREADY => S_AXI_1_AWREADY,
        S_AXI_AWVALID => S_AXI_1_AWVALID,
        S_AXI_BREADY => S_AXI_1_BREADY,
        S_AXI_BRESP(1 downto 0) => S_AXI_1_BRESP(1 downto 0),
        S_AXI_BVALID => S_AXI_1_BVALID,
        S_AXI_RDATA(31 downto 0) => S_AXI_1_RDATA(31 downto 0),
        S_AXI_RREADY => S_AXI_1_RREADY,
        S_AXI_RRESP(1 downto 0) => S_AXI_1_RRESP(1 downto 0),
        S_AXI_RVALID => S_AXI_1_RVALID,
        S_AXI_WDATA(31 downto 0) => S_AXI_1_WDATA(31 downto 0),
        S_AXI_WREADY => S_AXI_1_WREADY,
        S_AXI_WSTRB(3 downto 0) => S_AXI_1_WSTRB(3 downto 0),
        S_AXI_WVALID => S_AXI_1_WVALID,
        wb_ack_i => bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_ack_i,
        wb_addr_o(14 downto 2) => bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_adr_o(14 downto 2),
        wb_clk_o => bonfire_axi4l2wb_0_wb_clk_o,
        wb_cyc_o => bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_cyc_o,
        wb_dat_i(31 downto 0) => bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_dat_i(31 downto 0),
        wb_dat_o(31 downto 0) => bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_dat_o(31 downto 0),
        wb_rst_o => bonfire_axi4l2wb_0_wb_rst_o,
        wb_sel_o(3 downto 0) => NLW_bonfire_axi4l2wb_0_wb_sel_o_UNCONNECTED(3 downto 0),
        wb_stb_o => bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_stb_o,
        wb_we_o => bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_we_o
      );
      
  bonfire_gpio_0: component bonfire_gpio
       generic map (
         NUM_GPIO_BITS=>NUM_GPIO
       )
       port map (
        fall_irq_o => bonfire_gpio_0_fall_irq_o,
        gpio_i(NUM_GPIO-1 downto 0) => bonfire_gpio_0_GPIO_TRI_I(NUM_GPIO-1 downto 0),
        gpio_o(NUM_GPIO-1 downto 0) => bonfire_gpio_0_GPIO_TRI_O(NUM_GPIO-1 downto 0),
        gpio_t(NUM_GPIO-1 downto 0) => bonfire_gpio_0_GPIO_TRI_T(NUM_GPIO-1 downto 0),
        high_irq_o => bonfire_gpio_0_high_irq_o,
        low_irq_o => bonfire_gpio_0_low_irq_o,
        rise_irq_o => bonfire_gpio_0_rise_irq_o,
        wb_ack_o => bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_ack_i,
        wb_adr_i(7 downto 2) => bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_adr_o(7 downto 2),
        wb_clk_i => bonfire_axi4l2wb_0_wb_clk_o,
        wb_cyc_i => bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_cyc_o,
        wb_dat_i(31 downto 0) => bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_dat_o(31 downto 0),
        wb_dat_o(31 downto 0) => bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_dat_i(31 downto 0),
        wb_rst_i => bonfire_axi4l2wb_0_wb_rst_o,
        wb_stb_i => bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_stb_o,
        wb_we_i => bonfire_axi4l2wb_0_WB_MASTER_wb_dbus_we_o
      );

end Behavioral;
