# MICS-processor-VHDL
Project developed for the Hardware Laboratory discipline at UFMS

## Compiler
To compile your code file you must use the command line below
```shell
python compiler.py <input_file_directory> <output_file_directory>
```

Below is an example with the files used in the development of the project.
```shell
python compiler.py bin/code.bin bin/firmware.bin
```

## Testbench
You must use the sequence of comands below to use the testbenchs and test the project entities
```shell
ghdl -i *vhdl; ghdl -m <testbench_entity>; ghdl -r <testbench_entity> --wave=<wave_file_name>.ghw
```

Commands used to test the project
```shell
ghdl -i *vhdl; ghdl -m tb_memory; ghdl -r tb_memory --wave=wave_tb_memory.ghw
```
```shell
ghdl -i *vhdl; ghdl -m tb_codec; ghdl -r tb_codec --wave=wave_tb_codec.ghw
```
```shell
ghdl -i *vhdl; ghdl -m tb_cpu; ghdl -r tb_cpu --wave=wave_tb_cpu.ghw
```
```shell
ghdl -i *vhdl; ghdl -m tb_soc; ghdl -r tb_soc --wave=wave_tb_soc.ghw
```

## Output waves
Comand line to see the output waves
```shell
gtkwave <wave_file_name>.ghw
```

Commands used to test the project
```shell
gtkwave wave_tb_memory.ghw
```
```shell
gtkwave wave_tb_codec.ghw
```
```shell
gtkwave wave_tb_cpu.ghw
```
```shell
gtkwave wave_tb_soc.ghw
```
