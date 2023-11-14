LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE opcode IS
    CONSTANT size : NATURAL := 4;
    SUBTYPE type_instruction IS STD_LOGIC_VECTOR(2 * size - 1 DOWNTO 0);
    SUBTYPE type_opcode IS STD_LOGIC_VECTOR(size - 1 DOWNTO 0);

    CONSTANT type_hlt : type_opcode := x"0";
    CONSTANT type_in : type_opcode := x"1";
    CONSTANT type_out : type_opcode := x"2";
    CONSTANT type_puship : type_opcode := x"3";
    CONSTANT type_pushim : type_opcode := x"4";
    CONSTANT type_drop : type_opcode := x"5";
    CONSTANT type_dup : type_opcode := x"6";
    CONSTANT type_add : type_opcode := x"8";
    CONSTANT type_sub : type_opcode := x"9";
    CONSTANT type_nand : type_opcode := x"A";
    CONSTANT type_slt : type_opcode := x"B";
    CONSTANT type_shl : type_opcode := x"C";
    CONSTANT type_shr : type_opcode := x"D";
    CONSTANT type_jeq : type_opcode := x"E";
    CONSTANT type_jmp : type_opcode := x"F";

    FUNCTION is_equal (instruction_word : type_instruction; opcode_word : type_opcode) RETURN BOOLEAN;
END PACKAGE opcode;

PACKAGE BODY opcode IS
    FUNCTION is_equal (instruction_word : type_instruction; opcode_word : type_opcode) RETURN BOOLEAN IS
    BEGIN
        RETURN instruction_word(2 * size - 1 DOWNTO size) = opcode_word;
    END;
END PACKAGE BODY opcode;