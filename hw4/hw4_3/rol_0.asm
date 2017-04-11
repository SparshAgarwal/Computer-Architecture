//author Joanne and Sparsh

// r3 will save 5ED7 at the end

lbi r1,0xEB
slbi r1, 0xDA
lbi r2, 0x1	
rol r3, r1, r2
rol r3, r3, r2	
rol r3, r3, r2	
halt
