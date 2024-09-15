initial begin
    ACLK = 0;
    forever #5 ACLK = ~ACLK;  // 100 MHz clock
end

initial begin
    ARESETN = 0;
    #20 ARESETN = 1;  // Deassert reset after 20ns
end