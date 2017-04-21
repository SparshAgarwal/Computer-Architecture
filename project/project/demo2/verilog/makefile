
make: simple complex random demo2

simple:
	wsrun.pl -pipe -list /u/k/a/karu/courses/cs552/spring2016/handouts/testprograms/public/inst_tests/all.list  proc_hier_pbench *.v > out/Simple

complex:
	wsrun.pl -pipe -list ~karu/courses/cs552/spring2016/handouts/testprograms/public/complex_demo1/all.list  proc_hier_pbench *.v > out/Complex

random:
	wsrun.pl -pipe -list ~karu/courses/cs552/spring2016/handouts/testprograms/public/rand_simple/all.list   proc_hier_pbench *.v > out/RandomSimple
	wsrun.pl -pipe -list ~karu/courses/cs552/spring2016/handouts/testprograms/public/rand_complex/all.list   proc_hier_pbench *.v > out/RandomComplex
	wsrun.pl -pipe -list ~karu/courses/cs552/spring2016/handouts/testprograms/public/rand_ctrl/all.list   proc_hier_pbench *.v > out/RandomCtrl
	wsrun.pl -pipe -list ~karu/courses/cs552/spring2016/handouts/testprograms/public/rand_mem/all.list   proc_hier_pbench *.v > out/RandomMem

demo2:
	wsrun.pl -pipe -list ~karu/courses/cs552/spring2016/handouts/testprograms/public/complex_demo2/all.list   proc_hier_pbench *.v > out/ComplexDemo2


test:
	wsrun.pl -pipe -list tests/all.list  proc_hier_pbench *.v > out/tests

testsingle:
	wsrun.pl -pipe -wave -prog ~karu/courses/cs552/spring2016/handouts/testprograms/public/inst_tests/$(t).asm  proc_hier_pbench *.v > out/testsingle

