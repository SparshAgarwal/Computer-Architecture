
make: simplecache complexcache randomcache demo2cache

simplecache:
	wsrun.pl -pipe -align -list /u/k/a/karu/courses/cs552/spring2016/handouts/testprograms/public/inst_tests/all.list  proc_hier_pbench *.v > out/Simple

complexcache:
	wsrun.pl -pipe -align -list ~karu/courses/cs552/spring2016/handouts/testprograms/public/complex_demo1/all.list  proc_hier_pbench *.v > out/Complex

randomcache:
	wsrun.pl -pipe -align -list ~karu/courses/cs552/spring2016/handouts/testprograms/public/rand_simple/all.list   proc_hier_pbench *.v > out/RandomSimple
	wsrun.pl -pipe -align -list ~karu/courses/cs552/spring2016/handouts/testprograms/public/rand_complex/all.list   proc_hier_pbench *.v > out/RandomComplex
	wsrun.pl -pipe -align -list ~karu/courses/cs552/spring2016/handouts/testprograms/public/rand_ctrl/all.list   proc_hier_pbench *.v > out/RandomCtrl
	wsrun.pl -pipe -align -list ~karu/courses/cs552/spring2016/handouts/testprograms/public/rand_mem/all.list   proc_hier_pbench *.v > out/RandomMem

demo2cache:
	wsrun.pl -pipe -align -list ~karu/courses/cs552/spring2016/handouts/testprograms/public/complex_demo2/all.list   proc_hier_pbench *.v > out/ComplexDemo2

mytestcache:
	wsrun.pl -pipe -align -list tests/all.list  proc_hier_pbench *.v > out/tests

testsinglecache:
	wsrun.pl -pipe -align -wave -prog ~karu/courses/cs552/spring2016/handouts/testprograms/public/inst_tests/$(t).asm  proc_hier_pbench *.v > out/testsingle


