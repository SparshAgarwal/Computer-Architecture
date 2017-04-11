//author Joanne and Sparsh

//// r3 will save DAEB at the end

lbi r1,0xDA
slbi r1, 0xEB
lbi r2, 0x2	
rol r3, r1, r2
rol r3, r3, r2	
rol r3, r3, r2	
rol r3, r3, r2	
rol r3, r3, r2	
rol r3, r3, r2	
rol r3, r3, r2	
rol r3, r3, r2	
halt


