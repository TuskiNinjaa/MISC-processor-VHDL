# MICS-processor-VHDL
Project developed for the Hardware Laboratory discipline at UFMS

## Instructions

| OPCODE | Mnemonic | Description |
| :---: | :---: | :---: |
| 0x0 | HLT  | Interrupts execution indefinitely |
| 0x1 | IN  | Stacks a byte received from the codec |
| 0x2 | OUT  | Unstack a byte and sends it to the codec |
| 0x3 | PUSHIP | Stacks the address stored in the IP register |
| 0x4 | PUSH imm | Stacks a byte with the immediate value |
| 0x5 | DROP | Unstack a byte |
| 0x6 | DUP | Stack the value on the top |
| 0x8 | ADD | Unstack OP1 and OP2, stack OP1 + OP2 |
| 0x9 | SUB | Unstack OP1 and OP2, stack OP1 - OP2 |
| 0xA | NAND | Unstack OP1 and OP2, stack OP1 NAND OP2 |
| 0xB | SLT | Unstack OP1 and OP2, stack OP1 < OP2 (1 - true, 0 - false)|
| 0xC | SHL | Unstack OP1 and OP2, stack OP1 << OP2 |
| 0xD | SHR | Unstack OP1 and OP2, stack OP1 >> OP2 |
| 0xE | JEQ | Unstack OP1, OP2 and OP3, IP receives OP3 if OP1 is equal OP2 |
| 0xF | JMP | Unstack OP1, IP receives OP1 value |


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

## Creating your own test case
Create a .bin file inside the /bin folder with your code and run the comand below.
```shell
python compiler.py bin/<your_file_name>.bin bin/firmware.bin
```

The compiler will convert you code in bits and save inside the firmware.bin.

If you want, you can modify the bin/input.bin file, that represents the codec entity inputs. It will make the codec testbanch fail, because of the changes in the values.

The comand below will run the testbench for you script (remember to update the value of the constant "CONSTANT quantity_instruction" inside the file tb_soc.vhdl, to match the quantity of instruction on yor code.
```shell
ghdl -i *vhdl; ghdl -m tb_soc; ghdl -r tb_soc --wave=wave_tb_soc.ghw
```

You can see the output with:
```shell
gtkwave wave_tb_soc.ghw
```

